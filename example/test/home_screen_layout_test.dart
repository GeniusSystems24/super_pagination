import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:super_core/super_core.dart';
import 'package:super_pagination_example/features/home/presentation/pages/home_screen.dart';

void main() {
  Future<void> pumpHome(
    WidgetTester tester, {
    required Size size,
    required SuperDeviceMode mode,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    final typography = SuperTextTheme(
      isDesktop: mode == SuperDeviceMode.desktop,
    );
    await tester.pumpWidget(
      MaterialApp.router(
        theme: SuperMaterialThemeData.light(
          mode: mode,
          textTheme: typography,
          primaryTextTheme: typography,
        ),
        routerConfig: router,
      ),
    );
    await tester.pump();
  }

  testWidgets(
    'home example cards lay out on desktop without exceptions',
    (tester) async {
      await pumpHome(
        tester,
        size: const Size(1440, 900),
        mode: SuperDeviceMode.desktop,
      );

      expect(find.text('Basic ListView'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'home example cards lay out on mobile without exceptions',
    (tester) async {
      await pumpHome(
        tester,
        size: const Size(390, 844),
        mode: SuperDeviceMode.mobile,
      );

      expect(find.text('Basic ListView'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
