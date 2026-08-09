import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_core/super_core.dart';
import 'package:super_pagination/super_pagination.dart';

void main() {
  group('GeniusLink design-system integration', () {
    test('search theme derives from super_core light tokens', () {
      final theme = SuperSearchTheme.light();
      final colors = SuperPalette.bluePalette.toLightColorScheme();

      expect(theme.searchBoxBackgroundColor, SuperThemeData.light.inputBg);
      expect(theme.searchBoxTextColor, SuperThemeData.light.fg1);
      expect(theme.searchBoxBorderColor, SuperThemeData.light.border);
      expect(theme.searchBoxFocusedBorderColor, colors.primary);
      expect(
        theme.searchBoxBorderRadius,
        BorderRadius.circular(SuperThemeData.light.spacing.radiusControl),
      );
    });

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
      late SuperSearchTheme searchTheme;
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
              searchTheme = SuperSearchTheme.of(context);
              paginationTheme = SuperPaginationTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(
        searchTheme.searchBoxFocusedBorderColor,
        SuperPalette.greenPalette.primary,
      );
      expect(
        paginationTheme.loadingIndicatorColor,
        SuperPalette.greenPalette.primary,
      );
    });
  });
}
