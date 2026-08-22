import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_pagination/super_pagination.dart';

/// Custom page/list request used by four v5 datasource shapes.
///
/// Important: because [SuperPaginationCubit] advances pagination through
/// [SuperPaginationRequest.copyWith], custom subclasses must override
/// [copyWith] and return the same concrete request type.
class CustomRequest extends SuperPaginationRequest {
  const CustomRequest({
    super.page = 1,
    super.pageSize,
    super.filters,
    super.extra,
    super.searchQuery,
    required this.workspaceId,
    required this.status,
  });

  final String workspaceId;
  final String status;

  @override
  CustomRequest copyWith({
    int? page,
    int? pageSize,
    String? cursor,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? extra,
    String? searchQuery,
  }) {
    return CustomRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      filters: filters ?? this.filters,
      extra: extra ?? this.extra,
      searchQuery: searchQuery ?? this.searchQuery,
      workspaceId: workspaceId,
      status: status,
    );
  }
}

/// Custom cursor request used by the two cursor-aware datasource shapes.
///
/// Cursor subclasses should override both [copyWith] and [copyWithCursor].
/// The latter is what the cubit uses to advance [lastCursorNo].
class CustomCursorRequest extends SuperCursorPaginationRequest {
  const CustomCursorRequest({
    super.page = 1,
    super.pageSize,
    super.lastCursorNo,
    super.filters,
    super.extra,
    super.searchQuery,
    required this.workspaceId,
    required this.status,
  });

  final String workspaceId;
  final String status;

  @override
  CustomCursorRequest copyWith({
    int? page,
    int? pageSize,
    String? cursor,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? extra,
    String? searchQuery,
  }) {
    return CustomCursorRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      lastCursorNo: lastCursorNo,
      filters: filters ?? this.filters,
      extra: extra ?? this.extra,
      searchQuery: searchQuery ?? this.searchQuery,
      workspaceId: workspaceId,
      status: status,
    );
  }

  @override
  CustomCursorRequest copyWithCursor({
    int? page,
    int? pageSize,
    int? lastCursorNo,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? extra,
    String? searchQuery,
  }) {
    return CustomCursorRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      lastCursorNo: lastCursorNo ?? this.lastCursorNo,
      filters: filters ?? this.filters,
      extra: extra ?? this.extra,
      searchQuery: searchQuery ?? this.searchQuery,
      workspaceId: workspaceId,
      status: status,
    );
  }
}

/// Runnable example for custom request subclasses across all six v5 sources.
class V5CustomRequestsScreen extends StatelessWidget {
  const V5CustomRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('v5 · Custom requests'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'listFuture'),
              Tab(text: 'listStream'),
              Tab(text: 'pageFuture'),
              Tab(text: 'pageStream'),
              Tab(text: 'cursorFuture'),
              Tab(text: 'cursorStream'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ListFutureDemo(),
            _ListStreamDemo(),
            _PageFutureDemo(),
            _PageStreamDemo(),
            _CursorFutureDemo(),
            _CursorStreamDemo(),
          ],
        ),
      ),
    );
  }
}

const _pageRequest = CustomRequest(
  pageSize: 8,
  workspaceId: 'workspace-42',
  status: 'active',
  searchQuery: 'custom request',
);

const _cursorRequest = CustomCursorRequest(
  pageSize: 8,
  workspaceId: 'workspace-42',
  status: 'active',
  searchQuery: 'custom cursor request',
);

class _ListFutureDemo extends StatelessWidget {
  const _ListFutureDemo();

  @override
  Widget build(BuildContext context) {
    return _PageRequestDemo(
      title: 'CustomRequest + listFuture',
      description: 'Raw Future<List<T>> using a CustomRequest subclass.',
      provider: SuperPaginationProvider<String, CustomRequest>.listFuture(
        (context, request) async {
          await _delay();
          return _rawListItems('listFuture', request);
        },
      ),
    );
  }
}

class _ListStreamDemo extends StatelessWidget {
  const _ListStreamDemo();

  @override
  Widget build(BuildContext context) {
    return _PageRequestDemo(
      title: 'CustomRequest + listStream',
      description: 'Raw Stream<List<T>> using a CustomRequest subclass.',
      provider: SuperPaginationProvider<String, CustomRequest>.listStream(
        (context, request) => Stream<List<String>>.fromFuture(
          _delayedValue(_rawListItems('listStream', request)),
        ),
      ),
    );
  }
}

class _PageFutureDemo extends StatelessWidget {
  const _PageFutureDemo();

  @override
  Widget build(BuildContext context) {
    return _PageRequestDemo(
      title: 'CustomRequest + pageFuture',
      description: 'PagePaginationResult<T> keeps backend page metadata.',
      provider: SuperPaginationProvider<String, CustomRequest>.pageFuture(
        (context, request) async {
          await _delay();
          return _pageResult('pageFuture', request);
        },
      ),
    );
  }
}

class _PageStreamDemo extends StatelessWidget {
  const _PageStreamDemo();

  @override
  Widget build(BuildContext context) {
    return _PageRequestDemo(
      title: 'CustomRequest + pageStream',
      description: 'Stream<PagePaginationResult<T>> with the same custom request.',
      provider: SuperPaginationProvider<String, CustomRequest>.pageStream(
        (context, request) => Stream<PagePaginationResult<String>>.fromFuture(
          _delayedValue(_pageResult('pageStream', request)),
        ),
      ),
    );
  }
}

class _CursorFutureDemo extends StatelessWidget {
  const _CursorFutureDemo();

  @override
  Widget build(BuildContext context) {
    return _CursorRequestDemo(
      title: 'CustomCursorRequest + cursorFuture',
      description: 'The cubit advances lastCursorNo through copyWithCursor.',
      provider:
          SuperPaginationProvider<String, CustomCursorRequest>.cursorFuture(
        (context, request) async {
          await _delay();
          return _cursorResult('cursorFuture', request);
        },
      ),
    );
  }
}

class _CursorStreamDemo extends StatelessWidget {
  const _CursorStreamDemo();

  @override
  Widget build(BuildContext context) {
    return _CursorRequestDemo(
      title: 'CustomCursorRequest + cursorStream',
      description: 'CursorPaginationResult<T> from a realtime-style stream.',
      provider:
          SuperPaginationProvider<String, CustomCursorRequest>.cursorStream(
        (context, request) => Stream<CursorPaginationResult<String>>.fromFuture(
          _delayedValue(_cursorResult('cursorStream', request)),
        ),
      ),
    );
  }
}

class _PageRequestDemo extends StatelessWidget {
  const _PageRequestDemo({
    required this.title,
    required this.description,
    required this.provider,
  });

  final String title;
  final String description;
  final SuperPaginationProvider<String, CustomRequest> provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoCard(
          title: title,
          description: description,
          requestType: 'CustomRequest extends SuperPaginationRequest',
        ),
        Expanded(
          child: SuperPagination<String, CustomRequest>.withProvider(
            request: _pageRequest,
            provider: provider,
            invisibleItemsThreshold: 2,
            separator: const Divider(height: 1),
            itemBuilder: _itemBuilder,
          ),
        ),
      ],
    );
  }
}

class _CursorRequestDemo extends StatelessWidget {
  const _CursorRequestDemo({
    required this.title,
    required this.description,
    required this.provider,
  });

  final String title;
  final String description;
  final SuperPaginationProvider<String, CustomCursorRequest> provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoCard(
          title: title,
          description: description,
          requestType:
              'CustomCursorRequest extends SuperCursorPaginationRequest',
        ),
        Expanded(
          child: SuperPagination<String, CustomCursorRequest>.withProvider(
            request: _cursorRequest,
            provider: provider,
            invisibleItemsThreshold: 2,
            separator: const Divider(height: 1),
            itemBuilder: _itemBuilder,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.description,
    required this.requestType,
  });

  final String title;
  final String description;
  final String requestType;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 8),
            SelectableText(
              requestType,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _itemBuilder(BuildContext context, List<String> items, int index) {
  return ListTile(
    leading: CircleAvatar(child: Text('${index + 1}')),
    title: Text(items[index]),
    subtitle: const Text(
      'workspaceId/status are custom fields preserved while paging.',
    ),
  );
}

Future<void> _delay() =>
    Future<void>.delayed(const Duration(milliseconds: 180));

Future<T> _delayedValue<T>(T value) async {
  await _delay();
  return value;
}

List<String> _rawListItems(String source, CustomRequest request) {
  const totalPages = 4;
  final pageSize = request.pageSize ?? 8;
  if (request.page > totalPages) return const <String>[];

  // A short final page lets raw-list sources infer end-of-pagination.
  final count = request.page == totalPages ? 4 : pageSize;
  final start = (request.page - 1) * pageSize;

  return List<String>.generate(
    count,
    (index) =>
        '$source · item ${start + index + 1} · page ${request.page} · '
        '${request.workspaceId} · ${request.status}',
  );
}

PagePaginationResult<String> _pageResult(
  String source,
  CustomRequest request,
) {
  const totalPages = 4;
  final pageSize = request.pageSize ?? 8;
  final start = (request.page - 1) * pageSize;
  final items = request.page > totalPages
      ? const <String>[]
      : List<String>.generate(
          pageSize,
          (index) =>
              '$source · item ${start + index + 1} · page ${request.page} · '
              '${request.workspaceId} · ${request.status}',
        );

  return PagePaginationResult<String>(
    pageNumber: request.page,
    totalPages: totalPages,
    items: items,
    hasMore: request.page < totalPages,
  );
}

CursorPaginationResult<String> _cursorResult(
  String source,
  CustomCursorRequest request,
) {
  const totalItems = 28;
  final pageSize = request.pageSize ?? 8;
  final start = request.lastCursorNo ?? 0;
  final end = (start + pageSize).clamp(0, totalItems);
  final items = <String>[
    for (var value = start + 1; value <= end; value++)
      '$source · item $value · cursor ${request.lastCursorNo ?? 'start'} · '
          '${request.workspaceId} · ${request.status}',
  ];

  return CursorPaginationResult<String>(
    lastCursorNo: items.isEmpty ? request.lastCursorNo : end,
    totalItems: totalItems,
    items: items,
    hasMore: end < totalItems,
  );
}
