import 'package:flutter/material.dart';
import 'package:super_pagination/super_pagination.dart';

/// Demonstrates SuperPagination 5.1.0 `keepAlive`.
///
/// Switch between tabs after scrolling each list. With `keepAlive: true`,
/// Flutter retains each pagination subtree, including its internally-created
/// cubit and internal scroll controller, while the tab is off-screen.
class KeepAliveScreen extends StatelessWidget {
  const KeepAliveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('5.1.0 · keepAlive'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Recent'),
              Tab(text: 'Popular'),
              Tab(text: 'Archived'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _KeepAlivePaginationTab(scope: 'recent', seed: 0),
            _KeepAlivePaginationTab(scope: 'popular', seed: 1000),
            _KeepAlivePaginationTab(scope: 'archived', seed: 2000),
          ],
        ),
      ),
    );
  }
}

class _KeepAlivePaginationTab extends StatelessWidget {
  const _KeepAlivePaginationTab({
    required this.scope,
    required this.seed,
  });

  final String scope;
  final int seed;

  @override
  Widget build(BuildContext context) {
    return SuperPaginationListView<int, SuperPaginationRequest>.withProvider(
      keepAlive: true,
      request: SuperPaginationRequest(
        page: 1,
        pageSize: 20,
        filters: {'scope': scope},
      ),
      provider: SuperPaginationProvider<int, SuperPaginationRequest>.listFuture(
        (context, request) async {
          await Future<void>.delayed(const Duration(milliseconds: 180));

          final page = request.page;
          final pageSize = request.pageSize ?? 20;

          if (page > 8) return const <int>[];

          final start = seed + ((page - 1) * pageSize);
          return List<int>.generate(
            pageSize,
            (index) => start + index + 1,
          );
        },
      ),
      itemBuilder: (context, items, index) {
        final value = items[index];
        return ListTile(
          leading: CircleAvatar(child: Text('$value')),
          title: Text('$scope item $value'),
          subtitle: const Text(
            'Scroll, switch tabs, then return: cubit and scroll position stay alive.',
          ),
        );
      },
      separator: const Divider(height: 1),
      invisibleItemsThreshold: 4,
    );
  }
}
