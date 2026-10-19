import 'package:flutter/material.dart';

import '../state/load_status.dart';

class LoadStateBody extends StatelessWidget {
  const LoadStateBody({
    super.key,
    required this.status,
    required this.isEmpty,
    required this.error,
    required this.onRetry,
    required this.child,
    this.emptyTitle = 'Ничего не найдено',
    this.emptySubtitle = 'Измените поиск или сбросьте фильтры',
  });

  final LoadStatus status;
  final bool isEmpty;
  final String? error;
  final VoidCallback onRetry;
  final Widget child;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    if (status == LoadStatus.loading || status == LoadStatus.idle) {
      return const Center(child: CircularProgressIndicator());
    }
    if (status == LoadStatus.error) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 56,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Ошибка загрузки',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(error ?? 'Неизвестная ошибка', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }
    if (isEmpty) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                emptyTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(emptySubtitle, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    return child;
  }
}
