# Super Pagination Examples

Comprehensive examples for Super Pagination library v4.0.0.

## Quick Start

```dart
import 'package:super_pagination/super_pagination.dart';

// Basic usage
SuperPagination<Product, PaginationRequest>.listViewWithProvider(
  request: const PaginationRequest(page: 1, pageSize: 20),
  provider: PaginationProvider.future(fetchProducts),
  itemBuilder: (context, items, index) {
    return ListTile(title: Text(items[index].name));
  },
);
```

## Documentation by Category

| Category | Description | File |
|----------|-------------|------|
| **Basic** | Core pagination patterns (ListView, GridView, Pull-to-Refresh) | [docs/basic.md](docs/basic.md) |
| **Streams** | Real-time data updates (Single, Multi, Merged streams) | [docs/streams.md](docs/streams.md) |
| **Advanced** | Complex scenarios (Cursor, Scroll Control, Data Operations) | [docs/advanced.md](docs/advanced.md) |
| **Search** | Smart search components (Dropdown, Multi-Select, Theming) | [docs/search.md](docs/search.md) |
| **Errors** | Error handling patterns (Retry, Recovery, Graceful Degradation) | [docs/errors.md](docs/errors.md) |
| **Firebase** | Firebase integration (Firestore, Realtime DB, Offline) | [docs/firebase.md](docs/firebase.md) |

## Example App Categories

### Basic (7 examples)
- Basic ListView - Simple paginated ListView with products
- GridView - Paginated GridView with product cards
- Column Layout - Non-scrollable column inside scroll view
- Row Layout - Non-scrollable row inside scroll view
- Pull to Refresh - Swipe down to refresh content
- Filter & Search - Paginated list with filtering
- Retry Mechanism - Auto-retry with exponential backoff

### Streams (3 examples)
- Single Stream - Real-time updates from single stream
- Multi Stream - Multiple streams with different rates
- Merged Streams - Merge streams into unified stream

### Advanced (15 examples)
- Cursor Pagination - Cursor-based pagination
- Horizontal Scroll - Horizontal scrolling with pagination
- PageView - Swipeable pages with auto pagination
- Staggered Grid - Pinterest-like masonry layout
- Custom States - Custom loading, empty, error states
- Scroll Control - Programmatic scrolling
- beforeBuild Hook - Execute logic before rendering
- hasReachedEnd - Detect pagination end
- Custom View Builder - Complete control with custom builder
- Reorderable List - Drag and drop to reorder
- State Separation - Different UI for page states
- Smart Preloading - Load items before reaching end
- Data Operations - Add, remove, update, clear items
- Data Age & Expiration - Auto-refresh after expiration
- Sorting - Programmatic sorting

### Search (6 examples)
- Search Dropdown - Auto-positioning overlay
- Multi-Select Search - Select multiple items
- Form Validation - Validators & formatters
- Keyboard Navigation - Arrow keys, Enter, Escape
- Search Theming - Light, dark & custom themes
- Async States - Loading, empty & error states

### Firebase (6 examples)
- Firestore Pagination - Basic paginated queries
- Firestore Real-time - Live data updates
- Firestore Search - Search with SmartSearchDropdown
- Realtime Database - Firebase RTDB pagination
- Firestore Filters - Advanced filtering
- Offline Support - Offline persistence

### Errors (7 examples)
- Basic Error Handling - Simple error display with retry
- Network Errors - Timeout, 404, 500 error types
- Retry Patterns - Auto, exponential, limited retries
- Custom Error Widgets - Pre-built error widget styles
- Error Recovery - Cached data, fallback strategies
- Graceful Degradation - Offline mode, placeholders
- Load More Errors - Handle load more errors

## Navigation with go_router

The example app uses `go_router` for declarative routing:

```dart
// Navigate to an example
context.push(AppRoutes.basicListView);
context.push(AppRoutes.searchDropdown);
context.push(AppRoutes.firestorePagination);
```

## Running the Examples

```bash
cd example
flutter pub get
flutter run
```

## Dependencies

The example consumes the package through the local path declared in
`pubspec.yaml`:

```yaml
dependencies:
  super_pagination:
    path: ../
```

Firebase and navigation dependencies are listed in the example pubspec.

---

For more information, see the [README.md](../README.md) or visit [GitHub](https://github.com/GeniusSystems24/super_pagination).
