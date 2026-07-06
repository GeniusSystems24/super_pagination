# Verification Results

Static verification was executed with `python tool/verify_architecture.py` and
additional API/graph checks.

## Results

- Dart files checked: **135**
- Dart files under `lib`: **49**
- `part` files with valid owners: **31**
- Relative import/export/part targets missing: **0**
- Standalone library dependency cycles: **0**
- Original public declarations detected: **86**
- Original public declarations missing after refactor: **0**
- Public declarations after refactor: **107**
- New `SuperPagination*` aliases: **21**
- Existing `SmartPagination` named constructors preserved: **16**
- Flutter imports in Domain: **0**
- Flutter imports in Application: **0**
- Remaining `package:smart_pagination/...` imports: **0**
- Example source files using the new package import: **56**

## Compatibility checks

The original tests continue to use the `SmartPagination*` names while importing
the renamed package. A new alias test uses `SuperPagination*` constructors and
checks assignability to the former types. This verifies both naming styles at
compile/test time when Flutter SDK is available.

## Environment limitation

Flutter and Dart SDK executables are not installed in the current environment,
so `flutter analyze` and `flutter test` could not be executed here. Run these in
the package root after extraction:

```bash
flutter pub get
flutter analyze
flutter test
```
