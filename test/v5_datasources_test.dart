
import 'package:flutter_test/flutter_test.dart';
import 'package:super_pagination/super_pagination.dart';

void main() {
  test('PagePaginationResult exposes server pagination metadata', () {
    const result = PagePaginationResult<int>(
      pageNumber: 2,
      totalPages: 4,
      items: [3, 4],
      hasMore: true,
    );
    expect(result.pageNumber, 2);
    expect(result.totalPages, 4);
    expect(result.items, [3, 4]);
    expect(result.hasMore, isTrue);
  });

  test('OffsetPaginationResult exposes offset and total item metadata', () {
    const result = OffsetPaginationResult<int>(
      offset: 20,
      totalItems: 45,
      items: [21, 22],
      hasMore: true,
    );
    expect(result.offset, 20);
    expect(result.totalItems, 45);
    expect(result.items, [21, 22]);
    expect(result.hasMore, isTrue);
  });

  test('CursorPaginationResult exposes cursor and total item metadata', () {
    const result = CursorPaginationResult<int>(
      lastCursorNo: 20,
      totalItems: 25,
      items: [19, 20],
      hasMore: true,
    );
    expect(result.lastCursorNo, 20);
    expect(result.totalItems, 25);
  });

  test('cursor datasource advances lastCursorNo', () async {
    final requests = <int?>[];
    final cubit = SuperPaginationCubit<int, SuperCursorPaginationRequest>(
      request: const SuperCursorPaginationRequest(pageSize: 2),
      provider: SuperPaginationProvider.cursorFuture((context, request) async {
        requests.add(request.lastCursorNo);
        final start = request.lastCursorNo ?? 0;
        return CursorPaginationResult<int>(
          lastCursorNo: start + 2,
          totalItems: 4,
          items: [start + 1, start + 2],
          hasMore: start + 2 < 4,
        );
      }),
    );

    cubit.fetchPaginatedList();
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    cubit.markUserScroll();
    cubit.fetchPaginatedList();
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(requests, [null, 2]);
    expect((cubit.state as SuperPaginationLoaded<int>).hasReachedEnd, isTrue);
    await cubit.close();
  });

  test('setRequest persists the active request across refreshes', () async {
    final seenParity = <String?>[];
    final cubit = SuperPaginationCubit<int, SuperPaginationRequest>(
      request: const SuperPaginationRequest(
        pageSize: 2,
        filters: <String, dynamic>{'parity': 'odd'},
      ),
      provider: SuperPaginationProvider.listFuture((context, request) async {
        final parity = request.filters?['parity'] as String?;
        seenParity.add(parity);
        return parity == 'even' ? <int>[2, 4] : <int>[1, 3];
      }),
    );

    cubit.fetchPaginatedList();
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    cubit.setRequest(
      const SuperPaginationRequest(
        pageSize: 2,
        filters: <String, dynamic>{'parity': 'even'},
      ),
    );
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect((cubit.state as SuperPaginationLoaded<int>).items, [2, 4]);
    expect(cubit.currentRequest.filters?['parity'], 'even');

    cubit.refreshPaginatedList();
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(seenParity, ['odd', 'even', 'even']);
    await cubit.close();
  });
}
