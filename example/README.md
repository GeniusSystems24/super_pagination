# SuperPagination Example

A responsive GeniusLink showcase demonstrating pagination, streams, search, error handling, and Firebase integration with `SuperPagination`.

## Run

```bash
flutter pub get
flutter run
```

## Architecture

The example uses a feature-first Clean Architecture structure with MVC-oriented presentation:

```text
app/        application bootstrap, routing, theme, composition root
shared/     reusable domain entities, application contracts, infrastructure
features/   home, pagination, streams, search, errors, Firebase examples
```

Navigation is generated with `go_router_builder`. A functional `TypedShellRoute` hosts the nested navigator and keeps the responsive sidebar/rail visible for both section and detail routes. The dashboard and navigation consume `SuperMaterialThemeData`, `SuperThemeData`, `SuperText`, and `SuperTokens` from `super_core`.

Regenerate typed route helpers after changing route annotations:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The original import paths are retained as compatibility exports. New example code should import feature-first paths.

See [ARCHITECTURE.md](ARCHITECTURE.md) and [REFACTORING_REPORT_AR.md](REFACTORING_REPORT_AR.md).
