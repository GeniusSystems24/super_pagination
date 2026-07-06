# Example Verification Results

## Static verification completed

- Example Dart files inspected: **146**
- Feature page implementations: **56**
- Typed route classes preserved: **60 / 60**
- Route path declarations preserved: **60 / 60**
- Baseline public declarations: **142**
- Current public declarations: **149**
- Missing baseline public declarations: **0**
- Compatibility export files: **65**
- Missing local import/export/part targets: **0**
- Local import cycles: **0**
- Shared Domain/Application boundary violations: **0**
- Direct infrastructure imports from non-Firebase presentation: **0**
- Old `package:super_pagination/pagination.dart` imports in example source: **0**
- Old `package:smart_pagination/...` imports in example source: **0**

## Automated checks added

- `test/architecture_boundary_test.dart`
- `test/compatibility_exports_test.dart`
- `test/controllers_test.dart`
- `tool/verify_example_architecture.py`

## Commands run in this environment

```text
python tool/verify_architecture.py
python example/tool/verify_example_architecture.py
```

Both static architecture verifiers completed successfully.

## SDK limitation

Flutter and Dart executables are not installed in the execution environment, so `flutter analyze`, `dart format`, and `flutter test` could not be run here. The generated GoRouter file was preserved beside its owning router library, and tests were added for execution in the target Flutter workspace.
