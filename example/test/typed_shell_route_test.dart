import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('router uses a functional TypedShellRoute for application chrome', () {
    final source = File('lib/app/routing/app_router.dart').readAsStringSync();

    expect(
      source,
      contains('@TypedShellRoute<HomeShellRouteData>'),
    );
    expect(source, contains('return ExampleShell('));
    expect(source, contains(r'$navigatorKey = _shellNavigatorKey'));
  });

  test('example shell is implemented by super_navigation_sidebar', () {
    final source =
        File('lib/app/presentation/example_shell.dart').readAsStringSync();

    expect(source, contains('NavigationSidebarController<String>'));
    expect(source, contains('NavigationShell<String>'));
    expect(source, contains('NavigationSidebar<String>'));
    expect(source, contains('NavShortcutBinder<String>'));
    expect(source, isNot(contains('class _NavigationPanel')));
  });

  test('detail routes remain on the shell navigator', () {
    final source = File('lib/app/routing/app_router.dart').readAsStringSync();
    final detailSource = source.substring(
      source.indexOf('// Detail routes'),
      source.indexOf('// Router configuration'),
    );

    expect(detailSource, isNot(contains('_rootNavigatorKey')));
    expect(detailSource, contains('_shellNavigatorKey'));
  });
}
