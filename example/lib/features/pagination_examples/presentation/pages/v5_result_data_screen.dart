
import 'package:flutter/material.dart';
import 'package:super_pagination/super_pagination.dart';

/// Runnable v5 example comparing PagePaginationResult and CursorPaginationResult.
class V5ResultDataScreen extends StatelessWidget {
  const V5ResultDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('v5 · ResultData'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Page result'), Tab(text: 'Cursor result')],
          ),
        ),
        body: const TabBarView(children: [_PageResultDemo(), _CursorResultDemo()]),
      ),
    );
  }
}

class _PageResultDemo extends StatelessWidget {
  const _PageResultDemo();

  @override
  Widget build(BuildContext context) {
    return SuperPagination<int, SuperPaginationRequest>.withProvider(
      request: const SuperPaginationRequest(pageSize: 10),
      provider: SuperPaginationProvider.pageFuture((request) async {
        await Future<void>.delayed(const Duration(milliseconds: 180));
        const totalPages = 4;
        final start = (request.page - 1) * (request.pageSize ?? 10);
        final items = List<int>.generate(request.pageSize ?? 10, (i) => start + i + 1);
        return PagePaginationResult<int>(
          pageNumber: request.page,
          totalPages: totalPages,
          items: items,
          hasMore: request.page < totalPages,
        );
      }),
      itemBuilder: (context, items, index) => ListTile(
        leading: const Icon(Icons.description_outlined),
        title: Text('Page item ${items[index]}'),
      ),
      separator: const Divider(height: 1),
    );
  }
}

class _CursorResultDemo extends StatelessWidget {
  const _CursorResultDemo();

  @override
  Widget build(BuildContext context) {
    return SuperPagination<int, SuperCursorPaginationRequest>.withProvider(
      request: const SuperCursorPaginationRequest(pageSize: 10),
      provider: SuperPaginationProvider.cursorFuture((request) async {
        await Future<void>.delayed(const Duration(milliseconds: 180));
        const totalItems = 35;
        final start = request.lastCursorNo ?? 0;
        final end = (start + (request.pageSize ?? 10)).clamp(0, totalItems);
        final items = <int>[for (var n = start + 1; n <= end; n++) n];
        return CursorPaginationResult<int>(
          lastCursorNo: items.isEmpty ? request.lastCursorNo : items.last,
          totalItems: totalItems,
          items: items,
          hasMore: end < totalItems,
        );
      }),
      itemBuilder: (context, items, index) => ListTile(
        leading: const Icon(Icons.more_horiz),
        title: Text('Cursor item ${items[index]}'),
      ),
      separator: const Divider(height: 1),
    );
  }
}
