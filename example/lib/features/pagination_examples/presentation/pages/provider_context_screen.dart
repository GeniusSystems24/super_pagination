import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_pagination/super_pagination.dart';

/// Demonstrates the 5.1.0 provider callback signature:
/// `(BuildContext context, request)`.
class ProviderContextScreen extends StatelessWidget {
  const ProviderContextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<_ContextItemsRepository>(
      create: (_) => const _ContextItemsRepository(prefix: 'Widget tree'),
      child: Scaffold(
        appBar: AppBar(title: const Text('Provider BuildContext')),
        body: SuperPaginationListView<String, SuperPaginationRequest>.withProvider(
          request: const SuperPaginationRequest(page: 1, pageSize: 20),
          provider:
              SuperPaginationProvider<String, SuperPaginationRequest>.listFuture(
            (context, request) {
              final repository = context.read<_ContextItemsRepository>();
              return repository.fetch(request);
            },
          ),
          itemBuilder: (context, items, index) => ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(items[index]),
            subtitle: const Text(
              'Repository resolved with context.read<_ContextItemsRepository>()',
            ),
          ),
          separator: const Divider(height: 1),
          invisibleItemsThreshold: 4,
        ),
      ),
    );
  }
}

class _ContextItemsRepository {
  const _ContextItemsRepository({required this.prefix});

  final String prefix;

  Future<List<String>> fetch(SuperPaginationRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));

    final pageSize = request.pageSize ?? 20;
    if (request.page > 5) return const <String>[];

    final start = (request.page - 1) * pageSize;
    return List<String>.generate(
      pageSize,
      (index) => '$prefix item ${start + index + 1}',
    );
  }
}
