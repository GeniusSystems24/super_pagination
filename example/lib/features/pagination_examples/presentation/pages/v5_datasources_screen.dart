
import 'package:flutter/material.dart';

/// Reference screen for the six canonical v5 datasource shapes.
class V5DataSourcesScreen extends StatelessWidget {
  const V5DataSourcesScreen({super.key});

  static const _sources = <(String, String, String)>[
    ('listFuture', 'Future<List<T>>', 'REST APIs that only return item lists'),
    ('listStream', 'Stream<List<T>>', 'Realtime raw-list sources'),
    ('pageFuture', 'Future<PagePaginationResult<T>>', 'Page-number REST APIs'),
    ('pageStream', 'Stream<PagePaginationResult<T>>', 'Realtime page results'),
    ('cursorFuture', 'Future<CursorPaginationResult<T>>', 'Cursor REST APIs'),
    ('cursorStream', 'Stream<CursorPaginationResult<T>>', 'Realtime cursor APIs'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('v5 · Six datasources')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _sources.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final source = _sources[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('SuperPaginationProvider.${source.$1}'),
              subtitle: Text('${source.$2}\n${source.$3}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
