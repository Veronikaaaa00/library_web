import 'package:flutter_test/flutter_test.dart';
import 'package:library_web/models/book_query.dart';
import 'package:library_web/repositories/in_memory_book_repository.dart';

void main() {
  late InMemoryBookRepository repository;

  setUp(() {
    repository = InMemoryBookRepository();
  });

  test('seed содержит не менее 20 книг', () async {
    final page = await repository.find(const BookQuery(size: 50));
    expect(page.total, greaterThanOrEqualTo(20));
  });

  test('поиск по названию и ISBN', () async {
    final byTitle = await repository.find(const BookQuery(search: 'война'));
    expect(byTitle.items.any((b) => b.title.contains('Война')), isTrue);

    final byIsbn = await repository.find(
      const BookQuery(search: '978-5-17-090123-1'),
    );
    expect(byIsbn.items, isNotEmpty);
  });

  test('фильтры жанр + издательство + год комбинируются', () async {
    final page = await repository.find(
      const BookQuery(genreId: 1, publisherId: 1, yearFrom: 1800, yearTo: 1900),
    );
    for (final book in page.items) {
      expect(book.genreIds.contains(1), isTrue);
      expect(book.publisherId, 1);
      expect(book.year, inInclusiveRange(1800, 1900));
    }
  });

  test('пагинация режет страницы', () async {
    final first = await repository.find(const BookQuery(page: 1, size: 10));
    final second = await repository.find(const BookQuery(page: 2, size: 10));
    expect(first.items.length, 10);
    expect(second.items, isNotEmpty);
    expect(first.items.first.id, isNot(second.items.first.id));
  });

  test('deleteMany логически удаляет выбранные записи', () async {
    final before = await repository.find(const BookQuery(size: 50));
    final ids = before.items.take(2).map((b) => b.id).toList();
    final count = await repository.deleteMany(ids);
    expect(count, 2);

    final after = await repository.find(const BookQuery(size: 50));
    expect(after.items.any((b) => ids.contains(b.id)), isFalse);

    final withDeleted = await repository.find(
      const BookQuery(size: 50, includeDeleted: true),
    );
    final deleted = withDeleted.items.where((b) => ids.contains(b.id));
    expect(deleted.length, 2);
    expect(deleted.every((b) => b.isDeleted), isTrue);
  });

  test('restore снимает deletedAt', () async {
    await repository.softDelete(1);
    await repository.restore(1);
    final book = await repository.findById(1);
    expect(book?.isDeleted, isFalse);
  });

  test('BookQuery из URI и обратно', () {
    const query = BookQuery(
      search: 'война',
      genreId: 2,
      sortField: 'year',
      sortAscending: false,
      page: 3,
      size: 25,
    );
    final restored = BookQuery.fromUri(Uri.parse(query.toLocation()));
    expect(restored, query);
  });
}
