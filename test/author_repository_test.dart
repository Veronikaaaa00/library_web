import 'package:flutter_test/flutter_test.dart';
import 'package:library_web/models/author_query.dart';
import 'package:library_web/repositories/in_memory_author_repository.dart';

void main() {
  late InMemoryAuthorRepository repository;

  setUp(() {
    repository = InMemoryAuthorRepository();
  });

  test('seed содержит не менее 8 авторов', () async {
    final page = await repository.find(const AuthorQuery(size: 50));
    expect(page.total, greaterThanOrEqualTo(8));
  });

  test('поиск по фамилии и стране', () async {
    final byLastName = await repository.find(
      const AuthorQuery(search: 'толстой'),
    );
    expect(byLastName.items.any((a) => a.lastName == 'Толстой'), isTrue);

    final byCountry = await repository.find(
      const AuthorQuery(search: 'япония'),
    );
    expect(byCountry.items.any((a) => a.country == 'Япония'), isTrue);
  });

  test('фильтр страны и диапазона года рождения', () async {
    final page = await repository.find(
      const AuthorQuery(
        country: 'Россия',
        birthYearFrom: 1800,
        birthYearTo: 1900,
      ),
    );
    expect(page.items, isNotEmpty);
    for (final author in page.items) {
      expect(author.country, 'Россия');
      expect(author.birthYear, inInclusiveRange(1800, 1900));
    }
  });
}
