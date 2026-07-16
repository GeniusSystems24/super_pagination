# GeniusLink design-system migration

This package and its example app now consume `super_core` as the visual source of truth.

## Reference

- Repository: `GeniusSystems24/super_core`
- Package version: `1.2.0`
- Pinned commit: `1d8bdf959d37904ed6ed0bd4c81eab2127582af8`
- Minimum Flutter version: `3.32.0`

## Package changes

- Added `super_core` as a pinned Git dependency.
- Added `SuperPaginationTheme`, derived from the ambient `SuperThemeData` and `ColorScheme`.
- Reworked `SuperSearchTheme` so its default light/dark variants derive from `SuperPalette`, `SuperThemeData`, and `SuperTokens`.
- Updated built-in loading, empty, error, retry, dropdown, and overlay states to use GeniusLink surfaces, typography, radii, spacing, and semantic colors.
- Preserved extension overrides: applications may still register custom `SuperPaginationTheme` and `SuperSearchTheme` instances.

## Example changes

- Replaced the local app theme with responsive `SuperMaterialThemeData.light/dark`.
- The active `SuperDeviceMode` is selected from the viewport width.
- Rebuilt the example catalog surfaces, search, cards, status pills, shared product card, and theming demonstration with `super_core` components and tokens.
- Added live light/dark switching and palette demonstrations.

## Verification performed in this environment

- Parsed all modified YAML files successfully.
- Checked balanced Dart delimiters across modified sources.
- Checked imports and stale local-theme references.
- Added theme derivation widget tests in `test/design_system_theme_test.dart`.

The Flutter and Dart SDK executables were not available in the execution environment, so `flutter analyze` and `flutter test` could not be run here. Run them in a Flutter 3.32+ environment before publishing.
## Typed shell and example refresh (4.1.1)

- The example route tree now uses `TypedShellRoute<HomeShellRouteData>` as functional application chrome rather than a pass-through builder.
- `ExampleShell` provides responsive desktop/sidebar and tablet/rail navigation using `SuperThemeData` surfaces and `SuperTokens` motion.
- Detail pages stay on the shell navigator, preserving navigation context during deep links and transitions.
- The home catalog is now a responsive dashboard with a hero panel, category switcher, metrics, search, and adaptive card grid.


## Navigation sidebar integration (4.1.3)

- The example shell now consumes `GeniusSystems24/super_navigation_sidebar` 2.3.0 at pinned commit `2008cf2536212adf92657ebe096a503f934924b3`.
- The manual desktop/sidebar and tablet/rail widgets were removed in favor of `NavigationShell`, `NavigationSidebar`, and `NavigationSidebarController<String>`.
- The sidebar tree contains every typed GoRouter destination and mirrors `GoRouterState.uri.path`, while GoRouter remains the navigation source of truth.
- The example demonstrates adaptive expanded, rail, and drawer presentation, breadcrumbs, route filtering, command-palette search, favorites, recents, badges, and working keyboard shortcuts.
- `NavigationSidebarThemeData` is not duplicated locally; the library derives its palette, brightness, surfaces, and responsive metrics from the ambient `SuperMaterialThemeData`.
