import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/seed_data.dart';
import '../models/author.dart';
import '../models/book.dart';
import '../models/genre.dart';
import '../repositories/book_repository.dart';
import '../widgets/app_scaffold.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key, required this.bookId});

  final int bookId;

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Future<Book?> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<BookRepository>().findById(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Карточка книги',
      body: FutureBuilder<Book?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final book = snapshot.data;
          if (book == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Книга не найдена'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go('/books'),
                    child: const Text('К списку'),
                  ),
                ],
              ),
            );
          }

          final publisher = findPublisher(book.publisherId);
          final genres = book.genreIds
              .map(findGenre)
              .whereType<Genre>()
              .map((g) => g.name)
              .join(', ');
          final authors = book.authorIds
              .map(findSeedAuthor)
              .whereType<Author>()
              .map((a) => a.fullName)
              .join(', ');

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                book.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (book.isDeleted) ...[
                const SizedBox(height: 8),
                Chip(
                  label: const Text('Удалена логически'),
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                ),
              ],
              const SizedBox(height: 16),
              _row('ISBN', book.isbn),
              _row('Год', '${book.year}'),
              _row('Страниц', '${book.pages}'),
              _row('Издательство', publisher?.name ?? '—'),
              _row('Жанры', genres.isEmpty ? '—' : genres),
              _row('Авторы', authors.isEmpty ? '—' : authors),
              _row(
                'Экземпляры',
                '${book.copiesAvailable} из ${book.copiesTotal}',
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => context.go('/books'),
                child: const Text('Назад к списку'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
