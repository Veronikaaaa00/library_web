import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.size,
    required this.onPageChanged,
    required this.onSizeChanged,
    this.sizeOptions = const [10, 25, 50],
  });

  final int page;
  final int totalPages;
  final int total;
  final int size;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onSizeChanged;
  final List<int> sizeOptions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Записей: $total · стр. $page из $totalPages',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Первая',
          onPressed: page > 1 ? () => onPageChanged(1) : null,
          icon: const Icon(Icons.first_page),
        ),
        IconButton(
          tooltip: 'Предыдущая',
          onPressed: page > 1 ? () => onPageChanged(page - 1) : null,
          icon: const Icon(Icons.chevron_left),
        ),
        IconButton(
          tooltip: 'Следующая',
          onPressed: page < totalPages ? () => onPageChanged(page + 1) : null,
          icon: const Icon(Icons.chevron_right),
        ),
        IconButton(
          tooltip: 'Последняя',
          onPressed: page < totalPages ? () => onPageChanged(totalPages) : null,
          icon: const Icon(Icons.last_page),
        ),
        const SizedBox(width: 8),
        Text('На странице', style: Theme.of(context).textTheme.bodyMedium),
        DropdownButton<int>(
          value: sizeOptions.contains(size) ? size : sizeOptions.first,
          items: [
            for (final option in sizeOptions)
              DropdownMenuItem(value: option, child: Text('$option')),
          ],
          onChanged: (value) {
            if (value != null) onSizeChanged(value);
          },
        ),
      ],
    );
  }
}
