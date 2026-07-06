import 'package:flutter/widgets.dart' show SizedBox;
import 'package:flutter_test/flutter_test.dart';
import 'package:super_pagination/super_pagination.dart';

void main() {
  test('new SuperPagination model aliases preserve legacy types', () {
    const request = SuperPaginationRequest(page: 2, pageSize: 20);
    expect(request, isA<SuperPaginationRequest>());
    expect(request.page, 2);
  });

  test('new provider alias preserves provider behavior', () async {
    final SuperPaginationProvider<int, SuperPaginationRequest> provider =
        SuperPaginationProvider<int, SuperPaginationRequest>.future(
          (request) async => <int>[request.page],
        );

    expect(provider, isA<FutureSuperPaginationProvider<int, SuperPaginationRequest>>());
  });

  testWidgets('new widget alias exposes existing named constructors', (
    tester,
  ) async {
    final widget = SuperPagination<int, SuperPaginationRequest>.listViewWithProvider(
      request: const SuperPaginationRequest(pageSize: 10),
      provider: SuperPaginationProvider<int, SuperPaginationRequest>.future(
        (_) async => const <int>[],
      ),
      itemBuilder: (context, items, index) => const SizedBox.shrink(),
    );

    expect(widget, isA<SuperPagination<int, SuperPaginationRequest>>());
  });
}
