# Migration to SuperPagination 4.0

## Required change

Change the package segment in imports:

```dart
// Before
import 'package:smart_pagination/pagination.dart';

// After, minimal migration
import 'package:super_pagination/pagination.dart';

// After, canonical v4 entry point
import 'package:super_pagination/super_pagination.dart';
```

No constructor or callback change is required. Existing `SmartPagination*` names
remain available.

## Optional naming migration

New code may replace the prefix only:

```dart
SmartPagination<Product, PaginationRequest>.listViewWithProvider(...);
SuperPagination<Product, PaginationRequest>.listViewWithProvider(...);
```

Equivalent aliases are provided for widgets, cubits, controllers, states,
listeners, request/meta models, and providers.
