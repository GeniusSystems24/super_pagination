import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_pagination/super_pagination.dart';

void main() {
  test('keepAlive is exposed and defaults to false', () {
    final widget =
        SuperPaginationListView<int, SuperPaginationRequest>.withProvider(
          request: const SuperPaginationRequest(page: 1, pageSize: 10),
          provider:
              SuperPaginationProvider<int, SuperPaginationRequest>.listFuture(
                (context, _) async => const <int>[],
              ),
          itemBuilder: (context, items, index) => const SizedBox.shrink(),
        );

    expect(widget.keepAlive, isFalse);
  });

  testWidgets(
    'keepAlive preserves the same cubit and internal scroll controller in tabs',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              body: TabBarView(
                children: [
                  _TestPagination(key: ValueKey('first'), seed: 0),
                  _TestPagination(key: ValueKey('second'), seed: 100),
                  _TestPagination(key: ValueKey('third'), seed: 200),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final firstFinder = find.byKey(const ValueKey('first'));
      expect(firstFinder, findsOneWidget);

      final firstWidget = tester.widget<
          SuperPaginationListView<int, SuperPaginationRequest>>(
        firstFinder,
      );
      final firstCubit = firstWidget.cubit;

      final firstScrollable = find.descendant(
        of: firstFinder,
        matching: find.byType(Scrollable),
      ).first;
      final firstController =
          tester.widget<Scrollable>(firstScrollable).controller;

      final tabController = DefaultTabController.of(
        tester.element(firstFinder),
      );

      tabController.animateTo(2);
      await tester.pumpAndSettle();

      tabController.animateTo(0);
      await tester.pumpAndSettle();

      final returnedWidget = tester.widget<
          SuperPaginationListView<int, SuperPaginationRequest>>(
        firstFinder,
      );
      final returnedScrollable = find.descendant(
        of: firstFinder,
        matching: find.byType(Scrollable),
      ).first;
      final returnedController =
          tester.widget<Scrollable>(returnedScrollable).controller;

      expect(identical(returnedWidget.cubit, firstCubit), isTrue);
      expect(identical(returnedController, firstController), isTrue);
    },
  );
}

class _TestPagination extends StatelessWidget {
  const _TestPagination({
    super.key,
    required this.seed,
  });

  final int seed;

  @override
  Widget build(BuildContext context) {
    return SuperPaginationListView<int, SuperPaginationRequest>.withProvider(
      key: key,
      keepAlive: true,
      request: const SuperPaginationRequest(page: 1, pageSize: 10),
      provider: SuperPaginationProvider<int, SuperPaginationRequest>.listFuture(
        (context, request) async {
          if (request.page > 1) return const <int>[];
          return List<int>.generate(20, (index) => seed + index);
        },
      ),
      itemBuilder: (context, items, index) => SizedBox(
        height: 48,
        child: Text('${items[index]}'),
      ),
    );
  }
}
