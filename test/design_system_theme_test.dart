import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';
import 'package:super_pagination/super_pagination.dart';

void main() {
  group('GeniusLink design-system integration', () {
    test('pagination theme derives from super_core dark tokens', () {
      final theme = SuperPaginationTheme.dark();
      final colors = SuperPalette.bluePalette.toDarkColorScheme();

      expect(theme.loadingIndicatorColor, colors.primary);
      expect(theme.emptyTitleColor, SuperThemeData.dark.fg2);
      expect(theme.errorIconColor, colors.error);
      expect(theme.retryButtonColor, colors.primary);
    });

    testWidgets('ambient SuperMaterialThemeData is used without extensions',
        (tester) async {
      late SuperPaginationTheme paginationTheme;

      final typography = SuperTextTheme();
      await tester.pumpWidget(
        MaterialApp(
          theme: SuperMaterialThemeData.light(
            palette: SuperPalette.greenPalette,
            textTheme: typography,
            primaryTextTheme: typography,
          ),
          home: Builder(
            builder: (context) {
              paginationTheme = SuperPaginationTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(
        paginationTheme.loadingIndicatorColor,
        SuperPalette.greenPalette.primary,
      );
    });
  });
}
