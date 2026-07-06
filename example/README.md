# SuperPagination Example

A feature-rich Flutter application demonstrating pagination, streams, search, error handling, and Firebase integration with `SuperPagination`.

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

The original import paths are retained as compatibility exports. New example code should import feature-first paths.

See [ARCHITECTURE.md](ARCHITECTURE.md) and [REFACTORING_REPORT_AR.md](REFACTORING_REPORT_AR.md).
