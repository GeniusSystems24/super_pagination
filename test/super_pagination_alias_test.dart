import 'package:flutter/widgets.dart' show SizedBox;
import 'package:flutter_test/flutter_test.dart';
import 'package:super_pagination/super_pagination.dart';

void main() {
  test('new SuperPagination model aliases preserve legacy types', () {
    const request = SuperPaginationRequest(page: 2, pageSize: 20);
    expect(request, isA<PaginationRequest>());
    expect(request.page, 2);
  });

  test('new provider alias preserves provider behavior', () async {
    final SuperPaginationProvider<int, PaginationRequest> provider =
        PaginationProvider<int, PaginationRequest>.future(
          (request) async => <int>[request.page],
        );

    expect(provider, isA<FuturePaginationProvider<int, PaginationRequest>>());
  });

  testWidgets('new widget alias exposes existing named constructors', (
    tester,
  ) async {
    final widget = SuperPagination<int, PaginationRequest>.listViewWithProvider(
      request: const PaginationRequest(pageSize: 10),
      provider: PaginationProvider<int, PaginationRequest>.future(
        (_) async => const <int>[],
      ),
      itemBuilder: (context, items, index) => const SizedBox.shrink(),
    );

    expect(widget, isA<SmartPagination<int, PaginationRequest>>());
  });
}
