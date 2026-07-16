import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
import 'package:super_pagination/super_pagination.dart';

/// The example application consumes the same GeniusLink design system as every
/// package in the Super toolkit. No local color scheme is maintained here.
abstract final class AppTheme {
  static const SuperPalette palette = SuperPalette.bluePalette;

  static ThemeData light(SuperDeviceMode mode) =>
      SuperMaterialThemeData.light(
        palette: palette,
        mode: mode,
        extensions: [
          SuperSearchTheme.light(palette: palette),
          SuperPaginationTheme.light(palette: palette),
        ],
      );

  static ThemeData dark(SuperDeviceMode mode) => SuperMaterialThemeData.dark(
        palette: palette,
        mode: mode,
        extensions: [
          SuperSearchTheme.dark(palette: palette),
          SuperPaginationTheme.dark(palette: palette),
        ],
      );
}
