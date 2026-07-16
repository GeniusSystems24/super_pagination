import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';
import 'package:super_pagination_example/app/presentation/example_shell.dart';
import 'package:super_pagination_example/app/routing/app_routes.dart';

void main() {
  Future<void> pumpShell(
    WidgetTester tester, {
    required Size size,
    required String location,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: SuperMaterialThemeData.light(
          mode: SuperDeviceMode.forWidth(size.width),
        ),
        home: ExampleShell(
          location: location,
          navigator: const Scaffold(
            body: Center(child: Text('Nested route content')),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('uses expanded NavigationSidebar on desktop', (tester) async {
    await pumpShell(
      tester,
      size: const Size(1440, 900),
      location: AppRoutes.basic,
    );

    expect(find.byType(NavigationShell<String>), findsOneWidget);
    expect(find.byType(NavigationSidebar<String>), findsOneWidget);
    expect(find.text('Super Pagination'), findsOneWidget);
    expect(find.text('Basic ListView'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses drawer app bar on mobile section routes', (tester) async {
    await pumpShell(
      tester,
      size: const Size(390, 844),
      location: AppRoutes.search,
    );

    expect(find.byType(NavigationSidebarAppBar), findsOneWidget);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
