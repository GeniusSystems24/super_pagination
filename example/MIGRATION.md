# Example Import Migration

No existing example import path was removed. Legacy files now re-export the feature-first implementation.

## Recommended imports

```dart
import 'package:super_pagination_example/features/home/presentation/pages/home_screen.dart';
import 'package:super_pagination_example/shared/domain/entities/product.dart';
import 'package:super_pagination_example/app/routing/app_routes.dart';
```

## Compatible legacy imports

```dart
import 'package:super_pagination_example/screens/home_screen.dart';
import 'package:super_pagination_example/models/product.dart';
import 'package:super_pagination_example/router/app_router.dart';
```

Both forms expose the same public classes. Existing routes and locations are unchanged.
