# Example Verification Results

## Static verification completed

- Example Dart source files: **147**
- Typed `GoRouteData` classes: **60**
- Typed shell route classes: **1**
- `TypedGoRoute` declarations: **60**
- Detail route parent navigator declarations targeting the shell: **54**
- Missing local package import targets: **0**
- Dart files with syntax errors under the Tree-sitter Dart parser: **0 / 219**
- Duplicate named arguments detected in Dart invocation lists: **0**
- YAML parse failures: **0**
- Stale root-navigator references inside the detail-route section: **0**

## Automated checks added

- `test/architecture_boundary_test.dart`
- `test/compatibility_exports_test.dart`
- `test/controllers_test.dart`
- `test/typed_shell_route_test.dart`

## Checks run in this environment

- Parsed `pubspec.yaml` and `example/pubspec.yaml` successfully.
- Parsed package, test, example source, and example test Dart files with the Tree-sitter Dart grammar.
- Inspected every invocation AST for duplicate named arguments.
- Verified all local `package:super_pagination_example/...` and `package:super_pagination/...` import targets.
- Verified that `HomeShellRouteData` builds `ExampleShell` and all detail route parent keys use `_shellNavigatorKey`.
- Verified the generated `app_router.g.dart` remains present and compatible with the unchanged annotation topology.

## SDK limitation

Flutter and Dart executables are not installed in the execution environment, so `flutter analyze`, `dart format`, `flutter test`, and `build_runner` could not be executed here. Run the following in a Flutter 3.32+ workspace before publishing:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
```
