import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_pagination/super_pagination.dart';

void main() {
  testWidgets(
    'provider callback receives the live widget BuildContext',
    (tester) async {
      BuildContext? callbackContext;
      _Marker? resolvedMarker;

      await tester.pumpWidget(
        RepositoryProvider<_Marker>.value(
          value: const _Marker('from-widget-tree'),
          child: MaterialApp(
            home: Scaffold(
              body: SuperPaginationListView<int, SuperPaginationRequest>.withProvider(
                request: const SuperPaginationRequest(page: 1, pageSize: 5),
                provider:
                    SuperPaginationProvider<int, SuperPaginationRequest>.listFuture(
                  (context, request) async {
                    callbackContext = context;
                    resolvedMarker = context.read<_Marker>();
                    return List<int>.generate(
                      request.pageSize ?? 5,
                      (index) => index,
                    );
                  },
                ),
                itemBuilder: (context, items, index) => Text('${items[index]}'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(callbackContext, isNotNull);
      expect(callbackContext!.mounted, isTrue);
      expect(resolvedMarker?.value, 'from-widget-tree');
      expect(find.text('0'), findsOneWidget);
    },
  );

  testWidgets(
    'direct cubit construction can use providerContext',
    (tester) async {
      late BuildContext providerContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              providerContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      final cubit = SuperPaginationCubit<int, SuperPaginationRequest>(
        request: const SuperPaginationRequest(page: 1, pageSize: 2),
        providerContext: providerContext,
        provider: SuperPaginationProvider<int, SuperPaginationRequest>.listFuture(
          (context, request) async {
            expect(identical(context, providerContext), isTrue);
            return const <int>[1, 2];
          },
        ),
      );

      cubit.refreshPaginatedList();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.currentItems, <int>[1, 2]);
      await cubit.close();
    },
  );
}

class _Marker {
  const _Marker(this.value);

  final String value;
}
