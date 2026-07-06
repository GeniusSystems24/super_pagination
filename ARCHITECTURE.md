# SuperPagination Architecture

## Dependency direction

```text
Presentation (Flutter / MVC)
          ↓
Application (contracts and use policies)
          ↓
Domain (models and pagination errors)
```

`Domain` and `Application` do not import Flutter. Infrastructure-specific Flutter,
BLoC, logger, provider, and scroll-observer dependencies are composed only at the
Presentation boundary.

## Package layout

```text
lib/
├── super_pagination.dart              # Canonical public API
├── pagination.dart                    # Compatible entry point
├── core/ and data/                    # Compatible focused exports
└── src/
    ├── domain/
    │   ├── errors/
    │   └── models/
    ├── application/
    │   ├── contracts/
    │   └── services/
    ├── presentation/
    │   ├── pagination/
    │   │   ├── models/                # MVC Model
    │   │   ├── controllers/           # MVC Controllers
    │   │   └── views/                 # MVC Views
    │   └── search/
    │       ├── models/
    │       ├── controllers/
    │       └── views/
    └── public/
        └── super_pagination_aliases.dart
```

## SOLID application

- **Single Responsibility:** requests, metadata, retry policy, controllers,
  states, widgets, and search components live in focused modules.
- **Open/Closed:** providers and request subclasses remain extension points;
  callers can add Future, Stream, merged-stream, custom-request, and custom-view
  behavior without modifying package internals.
- **Liskov Substitution:** `SuperPagination*` aliases retain the exact types and
  constructors of `SmartPagination*`; custom `PaginationRequest` subclasses remain
  valid wherever the base request is accepted.
- **Interface Segregation:** state, listener, provider, cubit, and scroll-controller
  contracts are separated instead of requiring one broad interface.
- **Dependency Inversion:** controllers depend on `PaginationProvider` and contract
  types, while concrete Flutter views compose those controllers at the package edge.

## Compatibility policy

Canonical v4 import:

```dart
import 'package:super_pagination/super_pagination.dart';
```

Compatible entry point:

```dart
import 'package:super_pagination/pagination.dart';
```

Both naming styles are supported:

```dart
SuperPaginationListView.withProvider(...); // v4 canonical name
SmartPaginationListView.withProvider(...); // compatibility name
```

The package rename necessarily changes the package segment in imports from
`smart_pagination` to `super_pagination`. Widget constructors, callbacks, request
objects, providers, cubits, states, and behavior remain compatible.
