# SuperPagination Example Architecture

The example application is organized feature-first while preserving the original routes, page classes, and legacy import paths.

## Structure

```text
lib/
├── main.dart
├── app/
│   ├── bootstrap/
│   ├── controllers/
│   ├── dependencies/
│   ├── presentation/
│   ├── routing/
│   └── theme/
├── shared/
│   ├── domain/entities/
│   ├── application/contracts/
│   ├── infrastructure/services/
│   └── presentation/
├── features/
│   ├── home/
│   ├── pagination_examples/
│   ├── stream_examples/
│   ├── search_examples/
│   ├── error_examples/
│   └── firebase_examples/
├── models/      # compatibility exports
├── services/    # compatibility exports
├── widgets/     # compatibility exports
├── screens/     # compatibility exports
└── router/      # compatibility export
```

## Dependency direction

```text
Presentation -> Application contracts -> Domain
Infrastructure -> Application contracts -> Domain
App composition root -> Infrastructure + Presentation
```

The non-Firebase example pages do not import infrastructure implementations directly. They receive the demo catalog through `ExampleDependencies`, which exposes the application contract `DemoCatalogGateway`.

Firebase pages are intentionally isolated in the `firebase_examples` bounded context because those examples demonstrate Firebase-specific pagination APIs and document/query types. Shared Domain and Application code remain independent of Firebase and Flutter.

## MVC mapping

- **Model**: shared entities, feature presentation models, pagination requests and states.
- **View**: pages and reusable widgets under `presentation`.
- **Controller**: `AppThemeController`, `HomeController`, `SeedDataController`, plus the controllers/cubits supplied by SuperPagination.

## Compatibility

The former paths remain as export-only shims. For example:

```dart
import 'package:super_pagination_example/screens/home_screen.dart';
```

continues to expose the same `HomeScreen` class, while new code should use:

```dart
import 'package:super_pagination_example/features/home/presentation/pages/home_screen.dart';
```

All typed route classes and route locations are preserved. The route tree is rooted in `@TypedShellRoute<HomeShellRouteData>`:

- `HomeShellRouteData` builds `ExampleShell` around the generated nested navigator.
- Desktop uses a full navigation sidebar; tablet uses a compact rail; mobile lets each page use the full viewport.
- Detail routes target the shell navigator through `$parentNavigatorKey`, so shell chrome persists instead of being replaced by the root navigator.
- Section navigation remains deep-linkable through `/basic`, `/streams`, `/advanced`, `/search`, `/errors`, and `/firebase`.
