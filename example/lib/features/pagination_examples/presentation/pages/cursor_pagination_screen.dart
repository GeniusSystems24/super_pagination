
import 'package:flutter/material.dart';
import 'package:super_pagination/super_pagination.dart';
import 'package:super_pagination_example/features/pagination_examples/presentation/pages/v5_datasources_screen.dart';
import 'package:super_pagination_example/features/pagination_examples/presentation/pages/v5_result_data_screen.dart';
import 'package:super_pagination_example/features/pagination_examples/presentation/pages/v5_set_request_screen.dart';
import 'package:super_pagination_example/features/pagination_examples/presentation/pages/v5_custom_requests_screen.dart';
import 'package:super_pagination_example/features/pagination_examples/presentation/pages/keep_alive_screen.dart';
import 'package:super_pagination_example/features/pagination_examples/presentation/pages/provider_context_screen.dart';

/// v5 cursor pagination example using CursorPaginationResult.
class CursorPaginationScreen extends StatelessWidget {
  const CursorPaginationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagination v5 · Cursor')),
      body: Column(
        children: [
          _V5Navigation(
            onDataSources: () => _open(context, const V5DataSourcesScreen()),
            onResults: () => _open(context, const V5ResultDataScreen()),
            onSetRequest: () => _open(context, const V5SetRequestScreen()),
            onCustomRequests: () =>
                _open(context, const V5CustomRequestsScreen()),
            onKeepAlive: () => _open(context, const KeepAliveScreen()),
            onProviderContext: () =>
                _open(context, const ProviderContextScreen()),
          ),
          const Divider(height: 1),
          Expanded(
            child: SuperPagination<int, SuperCursorPaginationRequest>.withProvider(
              request: const SuperCursorPaginationRequest(pageSize: 15),
              provider: SuperPaginationProvider.cursorFuture((context, request) async {
                await Future<void>.delayed(const Duration(milliseconds: 250));
                const totalItems = 73;
                final start = request.lastCursorNo ?? 0;
                final end = (start + (request.pageSize ?? 15)).clamp(0, totalItems);
                final items = <int>[
                  for (var value = start + 1; value <= end; value++) value,
                ];
                return CursorPaginationResult<int>(
                  lastCursorNo: items.isEmpty ? request.lastCursorNo : items.last,
                  totalItems: totalItems,
                  items: items,
                  hasMore: end < totalItems,
                );
              }),
              itemBuilder: (context, items, index) {
                final value = items[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('$value')),
                  title: Text('Cursor item $value'),
                  subtitle: const Text('The next request uses lastCursorNo.'),
                );
              },
              separator: const Divider(height: 1),
              invisibleItemsThreshold: 4,
            ),
          ),
        ],
      ),
    );
  }

  static void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _V5Navigation extends StatelessWidget {
  const _V5Navigation({
    required this.onDataSources,
    required this.onResults,
    required this.onSetRequest,
    required this.onCustomRequests,
    required this.onKeepAlive,
    required this.onProviderContext,
  });

  final VoidCallback onDataSources;
  final VoidCallback onResults;
  final VoidCallback onSetRequest;
  final VoidCallback onCustomRequests;
  final VoidCallback onKeepAlive;
  final VoidCallback onProviderContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          OutlinedButton.icon(
            onPressed: onDataSources,
            icon: const Icon(Icons.hub_outlined),
            label: const Text('6 datasources'),
          ),
          OutlinedButton.icon(
            onPressed: onResults,
            icon: const Icon(Icons.data_object_outlined),
            label: const Text('ResultData'),
          ),
          OutlinedButton.icon(
            onPressed: onSetRequest,
            icon: const Icon(Icons.tune_rounded),
            label: const Text('setRequest'),
          ),
          OutlinedButton.icon(
            onPressed: onCustomRequests,
            icon: const Icon(Icons.tune_rounded),
            label: const Text('Custom requests'),
          ),
          OutlinedButton.icon(
            onPressed: onKeepAlive,
            icon: const Icon(Icons.layers_outlined),
            label: const Text('keepAlive'),
          ),
          OutlinedButton.icon(
            onPressed: onProviderContext,
            icon: const Icon(Icons.account_tree_outlined),
            label: const Text('Provider context'),
          ),
        ],
      ),
    );
  }
}
