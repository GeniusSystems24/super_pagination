# Super Pagination

> **v4 migration:** the package name is now `super_pagination`. Replace only the
> package segment in imports. Existing `SuperPagination*` API names remain
> available as compatibility aliases, while new code can use
> `SuperPagination*`.

[![pub package](https://img.shields.io/pub/v/super_pagination.svg)](https://pub.dev/packages/super_pagination)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-All-blueviolet)](https://flutter.dev)
[![Live Demo](https://img.shields.io/badge/Live_Demo-View-success)](https://geniussystems24.github.io/super_pagination)

**Production-ready Flutter pagination with built-in BLoC, search dropdowns, and error handling.**

```dart
SuperPaginationListView.withProvider(
  request: SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider<Type, SuperPaginationRequest>.future((req) => api.getProducts(req)),
  itemBuilder: (context, items, index) => ProductTile(items[index]),
)
```

## Features

- **7 Widget Classes** - ListView, GridView, PageView, StaggeredGrid, Column, Row, ReorderableList
- **Super Search** - Auto-positioning dropdown with key-based selection
- **Built-in BLoC** - State management included, or bring your own cubit
- **Error Handling** - 6 pre-built styles with first-page/load-more separation
- **Stream Support** - Future, Stream, and merged streams
- **Data Operations** - Insert, remove, update, replace, and refresh items with first/last/at targeting
- **Auto Expiration** - Configurable data age for global cubits
- **Load-More Safety** - Rapid scrolling can never trigger duplicate concurrent page requests; optional cross-page deduplication via `identityKey`

## Load-More Safety Behaviour

Spec 003 (`specs/003-load-more-guard/`) hardens load-more against duplicate concurrent fetches. The behaviour is **state-guard only** — there is no debounce or throttle timer.

- **Exactly one load-more is active per cubit at any time.** Additional `fetchPaginatedList()` calls while a request is in flight are silently dropped at the cubit level. The widget layer additionally schedules the trigger via `SchedulerBinding.addPostFrameCallback` so multiple item builders firing in the same build pass collapse to a single callback.
- **Empty load-more responses end the list without appending.** A short page (fewer items than `pageSize`) IS appended and ends the list. A non-empty load-more page leaves the list open for further fetches.
- **Errors never end the list.** A failed load-more sets `loadMoreError` on the loaded state; `hasReachedEnd` is unchanged. A subsequent `fetchPaginatedList()` (or `retryAfterError()` under `errorRetryStrategy.manual`) is allowed.
- **Refresh / search / filter changes reset every guard.** `refreshPaginatedList()` clears `_isFetching`, the in-flight per-page key, `hasReachedEnd`, and bumps the generation counter so any stale future or stream emission is discarded.

### Optional: cross-page item deduplication

Configure `identityKey` to drop items whose key already appears in an earlier accumulated page. The library never deduplicates silently — without `identityKey`, items are appended exactly as the provider returned them.

```dart
SuperPaginationCubit<Product, SuperPaginationRequest>(
  request: SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider.future(api.fetchProducts),
  identityKey: (product) => product.id,
);
```

### Error retry behaviour

After a load-more error, the `errorRetryStrategy` parameter controls the next attempt:

| Strategy | Effect |
| --- | --- |
| `none` (default) | Errors persist; only `refreshPaginatedList()` clears them |
| `manual` | `retryAfterError()` must be called explicitly |
| `automatic` | The next `fetchPaginatedList()` retries the failed page |

## Scroll Anchor Preservation

Spec 004 (`specs/004-scroll-anchor-preservation/`) preserves the user's
viewport position across load-more appends and prevents chain-triggered
auto-fetches caused by fast flings. Cross-references the load-more guard
above (spec 003) — the two features compose.

### How it works

1. **Capture (pre-fetch)**: just before each accepted load-more, the
   widget records a viewport anchor — the last fully-visible item's key
   (or its index, or a raw scroll offset, depending on what's available).
2. **Append**: the cubit emits the new state with appended items as
   before; nothing is rendered out of order.
3. **Restore (post-frame)**: after the framework lays out the appended
   items, the package jumps the scroll back to the captured anchor so
   the on-screen content is visually stable.
4. **Suppression**: the cubit ignores additional automatic load-more
   triggers until the user initiates a new drag-scroll gesture. This
   prevents a fast fling from chain-triggering page 3, 4, 5… in a single
   gesture.

### Anchor strategy by view type

| View type                 | Strategy            | Backed by                                  |
| ------------------------- | ------------------- | ------------------------------------------ |
| `ListView`                | `key` → `itemIndex` | `scrollview_observer` `ListObserver`       |
| `GridView`                | `key` → `itemIndex` | `scrollview_observer` `GridObserver`       |
| `CustomScrollView`/sliver | `key` → `itemIndex` | same observer (mounted on the items sliver)|
| `StaggeredGridView`       | `offset`            | `controller.position.pixels` snapshot      |
| `PageView`                | _no-op_             | out of scope (page-based, not scroll-based)|
| `ReorderableListView`     | _no-op_             | out of scope                               |
| `reverse: true` (any view)| _no-op_             | out of scope                               |

### Opt-out: `preserveScrollAnchorOnAppend`

Every public wrapper (`SuperPaginationListView`, `SuperPaginationGridView`,
…) accepts `preserveScrollAnchorOnAppend` (default `true`). Setting it to
`false` reverts to pre-3.5.0 behaviour — anchor capture, restore, and the
post-append suppression flag are all disabled.

```dart
SuperPaginationListView<Product, SuperPaginationRequest>.withProvider(
  request: SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider.future(api.fetchProducts),
  itemBuilder: (context, items, index) => ProductTile(items[index]),
  preserveScrollAnchorOnAppend: false, // legacy "stick to bottom" behavior
);
```

### Troubleshooting

- **The viewport jumps a half-row.** Anchor restore aligns the captured
  item's trailing edge with the viewport bottom. Variable-height items
  near the threshold may cause sub-row jumps; consider providing
  `itemKeyBuilder` so the package uses the more precise `key` strategy.
- **Load-more never re-fires after restore.** The post-append suppression
  is cleared by the user's next drag-scroll. Programmatic
  `controller.jumpTo(...)` does NOT clear it — call
  `cubit.markUserScroll()` explicitly if you want to bypass.
- **No anchor on PageView / ReorderableListView.** These view types are
  out of scope by design — their scroll model is page-based or
  reorder-based, not append-based.

## Installation

```yaml
dependencies:
  super_pagination: ^4.0.0
```

```dart
import 'package:super_pagination/pagination.dart';
```

## Quick Start

### ListView

```dart
SuperPaginationListView.withProvider(
  request: SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider<Type, SuperPaginationRequest>.future((req) => fetchProducts(req)),
  itemBuilder: (context, items, index) => ListTile(
    title: Text(items[index].name),
  ),
)
```

### GridView

```dart
SuperPaginationGridView.withProvider(
  request: SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider<Type, SuperPaginationRequest>.future((req) => fetchProducts(req)),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  itemBuilder: (context, items, index) => ProductCard(items[index]),
)
```

### With External Cubit

```dart
final cubit = SuperPaginationCubit<Product, SuperPaginationRequest>(
  request: SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider<Type, SuperPaginationRequest>.future(fetchProducts),
  dataAge: Duration(minutes: 5), // Auto-refresh stale data
);

SuperPaginationListView.withCubit(
  cubit: cubit,
  itemBuilder: (context, items, index) => ProductTile(items[index]),
)
```

---

## Widget Classes

| Widget | Layout | Use Case |
|--------|--------|----------|-|
| `SuperPaginationListView` | Vertical/horizontal list | Feeds, messages |
| `SuperPaginationGridView` | Multi-column grid | Catalogs, galleries |
| `SuperPaginationColumn` | Non-scrollable column | Embedded in ScrollView |
| `SuperPaginationRow` | Non-scrollable row | Chips, tags |
| `SuperPaginationPageView` | Swipeable pages | Onboarding, carousels |
| `SuperPaginationStaggeredGridView` | Masonry layout | Pinterest-style |
| `SuperPaginationReorderableListView` | Drag-and-drop | Task lists |

Each widget has two constructors:

- `.withProvider(...)` - Creates cubit internally
- `.withCubit(...)` - Uses external cubit

---

## Super Search

Search components with auto-positioning overlay and key-based selection.

### Basic Dropdown

```dart
SuperSearchDropdown<Product, int>.withProvider(
  request: SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider<Product, SuperPaginationRequest>.future((req) => api.search(req.searchQuery)),
  searchRequestBuilder: (query) => SuperPaginationRequest(page: 1, pageSize: 20, searchQuery: query),
  itemBuilder: (context, product) => ListTile(title: Text(product.name)),
  keyExtractor: (product) => product.id,
  onSelected: (product, id) => print('Selected: ${product.name} (ID: $id)'),
)
```

### Key-Based Selection

Select by ID instead of object reference - essential for edit forms and state management.

```dart
SuperSearchDropdown<Product, int>.withProvider(
  // ... provider config
  itemBuilder: (context, product) => ListTile(title: Text(product.name)),

  // Key-based selection
  keyExtractor: (product) => product.id,
  selectedKey: selectedProductId,
  onSelected: (product, id) => setState(() => selectedProductId = id),
  selectedKeyLabelBuilder: (id) => 'Product #$id (loading...)',
  showSelected: true,
)
```

### Multi-Selection

```dart
SuperSearchMultiDropdown<Product, int>.withProvider(
  // ... provider config
  keyExtractor: (product) => product.id,
  selectedKeys: selectedIds,
  onSelected: (products, ids) => setState(() => selectedIds = ids),
  maxSelections: 5,
)
```

### Bottom Sheet Mode

For mobile-friendly selection, use `displayMode: SearchDisplayMode.bottomSheet`:

```dart
SuperSearchMultiDropdown<Product, int>.withProvider(
  // ... provider config
  displayMode: SearchDisplayMode.bottomSheet,
  bottomSheetConfig: SuperSearchBottomSheetConfig(
    title: 'Select Products',
    confirmText: 'Done',
    showSelectedCount: true,
    showClearAllButton: true,
    heightFactor: 0.85,
  ),
  hintText: 'Tap to search...',
  onSelected: (products, ids) => setState(() => selectedIds = ids),
)
```

| Display Mode | Description |
|--------------|-------------|-|
| `SearchDisplayMode.overlay` | Default dropdown overlay |
| `SearchDisplayMode.bottomSheet` | Fullscreen bottom sheet |

### Components

| Component | Description |
|-----------|-------------|-|
| `SuperSearchDropdown<T, K>` | Single-selection search dropdown |
| `SuperSearchMultiDropdown<T, K>` | Multi-selection with chips |
| `SuperSearchController<T, K>` | Controller for programmatic control |
| `SuperSearchBox<T, K>` | Standalone search input |
| `SuperSearchOverlay<T, K>` | Standalone results overlay |
| `SuperSearchTheme` | ThemeExtension for styling |

### Configuration

```dart
SuperSearchDropdown<Product, int>.withProvider(
  // ...
  searchConfig: SuperSearchConfig(
    debounceDelay: Duration(milliseconds: 500),
    minSearchLength: 2,
    searchOnEmpty: false,
  ),
  overlayConfig: SuperSearchOverlayConfig(
    position: OverlayPosition.auto,
    maxHeight: 400,
    animationType: OverlayAnimationType.fadeScale,
  ),
)
```

### SuperSearchDropdown Parameters

#### Core Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `request` | `SuperPaginationRequest` | Yes*| - | Pagination config (for `.withProvider`) |
| `provider` | `SuperPaginationProvider<T, SuperPaginationRequest>` | Yes* | - | Data source (for `.withProvider`) |
| `cubit` | `SuperPaginationCubit<T, SuperPaginationRequest>` | Yes* | - | External cubit (for `.withCubit`) |
| `searchRequestBuilder` | `SuperPaginationRequest Function(String)` | Yes | - | Builds request from search query |
| `itemBuilder` | `Widget Function(BuildContext, T)` | Yes | - | Builds each result item |

#### Selection Callback

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `onSelected` | `void Function(T, K)?` | No | `null` | Called with item and key when selected |
| `onChanged` | `ValueChanged<String>?` | No | `null` | Called when text changes |

#### Key-Based Selection

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `keyExtractor` | `K Function(T)?` | No | `null` | Extracts unique key from item |
| `selectedKey` | `K?` | No | `null` | Currently selected key |
| `selectedKeyLabelBuilder` | `String Function(K)?` | No | `null` | Label for pending key |
| `selectedKeyBuilder` | `Widget Function(BuildContext, K, VoidCallback)?` | No | `null` | Custom pending key widget |

#### Show Selected Mode

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `showSelected` | `bool` | No | `false` | Show selected item instead of search box |
| `initialSelectedValue` | `T?` | No | `null` | Pre-selected item on load |
| `selectedItemBuilder` | `Widget Function(BuildContext, T, VoidCallback)?` | No | `null` | Custom selected item widget |

#### Search Box Appearance

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `decoration` | `InputDecoration?` | No | `null` | TextField decoration |
| `style` | `TextStyle?` | No | `null` | Text style |
| `prefixIcon` | `Widget?` | No | `null` | Leading icon |
| `suffixIcon` | `Widget?` | No | `null` | Trailing icon |
| `showClearButton` | `bool` | No | `true` | Show clear button |
| `borderRadius` | `BorderRadius?` | No | `null` | Border radius |

#### Input Configuration

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `textInputAction` | `TextInputAction` | No | `search` | Keyboard action button |
| `textCapitalization` | `TextCapitalization` | No | `none` | Text capitalization |
| `keyboardType` | `TextInputType` | No | `text` | Keyboard type |
| `inputFormatters` | `List<TextInputFormatter>?` | No | `null` | Input formatters |
| `maxLength` | `int?` | No | `null` | Max input length |

#### Validation

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `validator` | `String? Function(String?)?` | No | `null` | Validation function |
| `autovalidateMode` | `AutovalidateMode?` | No | `null` | When to validate |

#### Overlay State Builders

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `loadingBuilder` | `WidgetBuilder?` | No | `null` | Loading state widget |
| `emptyBuilder` | `WidgetBuilder?` | No | `null` | Empty results widget |
| `errorBuilder` | `Widget Function(BuildContext, Exception)?` | No | `null` | Error state widget |
| `headerBuilder` | `WidgetBuilder?` | No | `null` | Dropdown header |
| `footerBuilder` | `WidgetBuilder?` | No | `null` | Dropdown footer |
| `separatorBuilder` | `IndexedWidgetBuilder?` | No | `null` | Item separator |
| `overlayDecoration` | `BoxDecoration?` | No | `null` | Overlay container decoration |

#### Configuration Objects

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `searchConfig` | `SuperSearchConfig` | No | `SuperSearchConfig()` | Search behavior config |
| `overlayConfig` | `SuperSearchOverlayConfig` | No | `SuperSearchOverlayConfig()` | Overlay appearance config |

#### Cubit Options (`.withProvider` only)

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `listBuilder` | `List<T> Function(List<T>)?` | No | `null` | Transform items |
| `onInsertionCallback` | `void Function(List<T>)?` | No | `null` | Called on data load |
| `maxPagesInMemory` | `int` | No | `5` | Max cached pages |
| `retryConfig` | `RetryConfig?` | No | `null` | Retry configuration |
| `dataAge` | `Duration?` | No | `null` | Data expiration |
| `orders` | `SortOrderCollection<T>?` | No | `null` | Sort orders |
| `logger` | `Logger?` | No | `null` | Debug logger |

---

### SuperSearchMultiDropdown Parameters

#### Multi Core Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `request` | `SuperPaginationRequest` | Yes*| - | Pagination config (for `.withProvider`) |
| `provider` | `SuperPaginationProvider<T, SuperPaginationRequest>` | Yes* | - | Data source (for `.withProvider`) |
| `cubit` | `SuperPaginationCubit<T, SuperPaginationRequest>` | Yes* | - | External cubit (for `.withCubit`) |
| `searchRequestBuilder` | `SuperPaginationRequest Function(String)` | Yes | - | Builds request from search query |
| `itemBuilder` | `Widget Function(BuildContext, T)` | Yes | - | Builds each result item |

#### Multi Selection Callback

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `onSelected` | `void Function(List<T>, List<K>)?` | No | `null` | Called with items and keys when selection changes |
| `onChanged` | `ValueChanged<String>?` | No | `null` | Called when text changes |
| `maxSelections` | `int?` | No | `null` | Maximum items to select |

#### Multi Key-Based Selection

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `keyExtractor` | `K Function(T)?` | No | `null` | Extracts unique key from item |
| `selectedKeys` | `List<K>?` | No | `null` | Currently selected keys |
| `selectedKeyLabelBuilder` | `String Function(K)?` | No | `null` | Label for pending keys |
| `selectedKeyBuilder` | `Widget Function(BuildContext, K, VoidCallback)?` | No | `null` | Custom pending key chip |

#### Multi Show Selected Mode

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `showSelected` | `bool` | No | `true` | Show selected chips below search |
| `initialSelectedValues` | `List<T>?` | No | `null` | Pre-selected items on load |
| `selectedItemBuilder` | `Widget Function(BuildContext, T, VoidCallback)?` | No | `null` | Custom selected chip |

#### Multi Selected Items Layout

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `selectedItemsWrap` | `bool` | No | `true` | Wrap chips or scroll horizontally |
| `selectedItemsSpacing` | `double` | No | `8.0` | Horizontal spacing between chips |
| `selectedItemsRunSpacing` | `double` | No | `8.0` | Vertical spacing when wrapped |
| `selectedItemsPadding` | `EdgeInsets` | No | `EdgeInsets.only(top: 12)` | Padding around chips container |

#### Multi Search Box Appearance

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `decoration` | `InputDecoration?` | No | `null` | TextField decoration |
| `style` | `TextStyle?` | No | `null` | Text style |
| `prefixIcon` | `Widget?` | No | `null` | Leading icon |
| `suffixIcon` | `Widget?` | No | `null` | Trailing icon |
| `showClearButton` | `bool` | No | `true` | Show clear button |
| `borderRadius` | `BorderRadius?` | No | `null` | Border radius |

#### Multi Input Configuration

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `textInputAction` | `TextInputAction` | No | `search` | Keyboard action button |
| `textCapitalization` | `TextCapitalization` | No | `none` | Text capitalization |
| `keyboardType` | `TextInputType` | No | `text` | Keyboard type |
| `inputFormatters` | `List<TextInputFormatter>?` | No | `null` | Input formatters |
| `maxLength` | `int?` | No | `null` | Max input length |

#### Multi Validation

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `validator` | `String? Function(String?)?` | No | `null` | Validation function |
| `autovalidateMode` | `AutovalidateMode?` | No | `null` | When to validate |

#### Multi Overlay State Builders

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `loadingBuilder` | `WidgetBuilder?` | No | `null` | Loading state widget |
| `emptyBuilder` | `WidgetBuilder?` | No | `null` | Empty results widget |
| `errorBuilder` | `Widget Function(BuildContext, Exception)?` | No | `null` | Error state widget |
| `headerBuilder` | `WidgetBuilder?` | No | `null` | Dropdown header |
| `footerBuilder` | `WidgetBuilder?` | No | `null` | Dropdown footer |
| `separatorBuilder` | `IndexedWidgetBuilder?` | No | `null` | Item separator |
| `overlayDecoration` | `BoxDecoration?` | No | `null` | Overlay container decoration |

#### Multi Configuration Objects

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `searchConfig` | `SuperSearchConfig` | No | `SuperSearchConfig()` | Search behavior config |
| `overlayConfig` | `SuperSearchOverlayConfig` | No | `SuperSearchOverlayConfig()` | Overlay appearance config |

#### Multi Cubit Options (`.withProvider` only)

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|-|
| `listBuilder` | `List<T> Function(List<T>)?` | No | `null` | Transform items |
| `onInsertionCallback` | `void Function(List<T>)?` | No | `null` | Called on data load |
| `maxPagesInMemory` | `int` | No | `5` | Max cached pages |
| `retryConfig` | `RetryConfig?` | No | `null` | Retry configuration |
| `dataAge` | `Duration?` | No | `null` | Data expiration |
| `orders` | `SortOrderCollection<T>?` | No | `null` | Sort orders |
| `logger` | `Logger?` | No | `null` | Debug logger |

---

## Error Handling

### Separate First-Page and Load-More Errors

```dart
SuperPaginationListView.withProvider(
  // ...
  firstPageErrorBuilder: (context, error, retry) => CustomErrorBuilder.material(
    context: context,
    error: error,
    onRetry: retry,
    title: 'Failed to load',
  ),
  loadMoreErrorBuilder: (context, error, retry) => CustomErrorBuilder.compact(
    context: context,
    error: error,
    onRetry: retry,
  ),
)
```

### Pre-Built Styles

| Style | Best For |
|-------|----------|-|
| `CustomErrorBuilder.material()` | First page errors |
| `CustomErrorBuilder.compact()` | Load more errors |
| `CustomErrorBuilder.card()` | Card-based UIs |
| `CustomErrorBuilder.minimal()` | Simple designs |
| `CustomErrorBuilder.snackbar()` | Non-blocking errors |
| `CustomErrorBuilder.custom()` | Custom widgets |

### Automatic Retry

```dart
SuperPaginationCubit<Product, SuperPaginationRequest>(
  request: SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider<Product, SuperPaginationRequest>.future(fetchProducts),
  retryConfig: RetryConfig(
    maxAttempts: 3,
    initialDelay: Duration(seconds: 1),
    shouldRetry: (error) => error is NetworkException,
  ),
)
```

---

## Data Operations

Programmatically manipulate items through the cubit. All methods return `Future<bool>` indicating success.

### Insert

```dart
await cubit.insertEmit(newProduct);                        // insert at index 0
await cubit.insertAllEmit([product1, product2], index: 0); // insert multiple
await cubit.addOrUpdateEmit(product);                      // add if new, update if exists
```

### Remove

```dart
await cubit.removeItemEmit(product);                       // remove by value
await cubit.removeAtEmit(2);                               // remove at index
await cubit.removeWhereEmit((p) => p.stock == 0);          // remove all matches
await cubit.removeFirstWhereEmit((p) => p.stock == 0);     // remove first match
await cubit.removeLastWhereEmit((p) => p.isArchived);      // remove last match
```

### Update

Applies a transform function to the matched item(s).

```dart
await cubit.updateItemEmit(
  (p) => p.id == productId,
  (p) => p.copyWith(price: newPrice),
); // first match

await cubit.updateWhereEmit(
  (p) => p.category == 'sale',
  (p) => p.copyWith(discount: 0.2),
); // all matches

await cubit.updateFirstWhereEmit(
  (p) => p.isPinned,
  (p) => p.copyWith(isPinned: false),
); // explicitly first match

await cubit.updateLastWhereEmit(
  (p) => p.isPinned,
  (p) => p.copyWith(isPinned: false),
); // last match

await cubit.updateAtEmit(0, (p) => p.copyWith(isFeatured: true)); // at index
```

### Replace

Swaps the matched item with a new instance directly (no updater function).

```dart
await cubit.replaceFirstWhereEmit((p) => p.id == id, updatedProduct); // first match
await cubit.replaceLastWhereEmit((p) => p.isDraft, publishedProduct);  // last match
await cubit.replaceAtEmit(3, newProduct);                              // at index
```

### Refresh

Async re-fetch of a specific item from the server.

```dart
await cubit.refreshItem(
  (p) => p.id == productId,
  (p) => api.fetchProduct(p.id),
); // first match

await cubit.refreshFirstWhereEmit(
  (p) => p.isStale,
  (p) => api.fetchProduct(p.id),
); // explicitly first match

await cubit.refreshLastWhereEmit(
  (p) => p.isStale,
  (p) => api.fetchProduct(p.id),
); // last match

await cubit.refreshAtEmit(0, (p) => api.fetchProduct(p.id)); // at index
```

### Bulk

```dart
await cubit.clearItems();
await cubit.setItems(customList);
cubit.reload();
```

---

## Partial Updates & Animations

Enable targeted UI updates instead of full list rebuilds by providing `itemKeyBuilder`:

```dart
SuperPaginationListView.withCubit(
  cubit: cubit,
  itemKeyBuilder: (item, index) => item.id,
  insertItemAnimationBuilder: (context, index, animation, child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(animation),
      child: child,
    );
  },
  removeItemAnimationBuilder: (context, index, animation, child) {
    return FadeTransition(opacity: animation, child: child);
  },
  animationDuration: const Duration(milliseconds: 400),
  itemBuilder: (context, items, index) => ProductTile(product: items[index]),
);
```

ListView uses `SliverAnimatedList` for insert/remove animations. Other view types (GridView, PageView, etc.) use key-based widget reconciliation for efficient partial updates without animations.

---

## Sorting

```dart
final orders = SortOrderCollection<Product>(
  orders: [
    SortOrder.byField(id: 'name', label: 'Name', fieldSelector: (p) => p.name),
    SortOrder.byField(id: 'price', label: 'Price', fieldSelector: (p) => p.price),
  ],
  defaultOrderId: 'name',
);

final cubit = SuperPaginationCubit<Product, SuperPaginationRequest>(
  request: SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider<Product, SuperPaginationRequest>.future(fetchProducts),
  orders: orders,
);

// Change sort
cubit.setActiveOrder('price');
cubit.resetOrder();
```

---

## Data Providers

### Future (REST API)

```dart
SuperPaginationProvider.future((request) => api.fetchProducts(request))
```

### Stream (Real-time)

```dart
SuperPaginationProvider.stream((request) => firestore.collection('products').snapshots())
```

#### Stream Accumulation

Stream pagination accumulates per-page subscriptions within a pagination scope. When a user loads page 2, the page 1 stream stays subscribed; when they load page 3, page 2 stays subscribed too. Emissions on any active page update only that page's slice; the merged list always reflects `page1 ∪ page2 ∪ … ∪ pageN` in page order.

The cubit owns one subscription per page in an internal registry. All accumulated subscriptions are cancelled together on a **scope reset**: refresh, reload, filter change, search-query change, provider replacement, page eviction (via `maxPagesInMemory`), or cubit dispose. Stale emissions buffered before a reset are dropped via a generation token.

#### End-of-pagination semantics

A page whose latest emission has fewer items than `pageSize` is treated as the end of pagination. While at least one active page is in this state the cubit rejects subsequent `loadMore()` calls. The rule is dynamic: if a later emission grows a partial page back to a full page, `loadMore()` is re-enabled in the same scope. An empty list `[]` emission is honoured — it clears that page's slice and triggers end-of-pagination, just like any other partial emission.

### Merged Streams

```dart
SuperPaginationProvider.mergeStreams((request) => [
  regularStream(request),
  featuredStream(request),
])
```

The merged provider supports zero, one, or many input streams. The single-stream case is wrapped in a controller for lifecycle symmetry: cancelling the merged subscription cancels every underlying child subscription. The merged stream completes only when every child has completed.

### Per-Page Error Annotation

When a stream provider's page errors, the cubit isolates the failure to that page rather than transitioning to a global error state. The failing page's subscription is cancelled, sibling pages keep emitting, and the page's last good slice remains in the merged view alongside an entry in `state.pageErrors`:

```dart
BlocBuilder<SuperPaginationCubit<Product, ProductRequest>, SuperPaginationState<Product>>(
  builder: (context, state) {
    if (state is! SuperPaginationLoaded<Product>) return const SizedBox.shrink();

    return Column(
      children: [
        if (state.pageErrors.isNotEmpty)
          MaterialBanner(
            content: Text('Failed to refresh ${state.pageErrors.length} page(s)'),
            actions: const [SizedBox.shrink()],
          ),
        Expanded(child: ProductList(items: state.items)),
      ],
    );
  },
)
```

`state.pageErrors` is a `Map<int, Object>` keyed by 1-based page index. Empty when no per-page error is in flight. A successful subsequent emission on the same page (after re-subscribing via a refresh) clears its annotation.

---

## Common Parameters

| Parameter | Type | Description |
|-----------|------|-------------|-|
| `request` | `SuperPaginationRequest` | Page number and size |
| `provider` | `SuperPaginationProvider<T, SuperPaginationRequest>` | Data source |
| `itemBuilder` | `Widget Function(context, items, index)` | Item widget builder |
| `invisibleItemsThreshold` | `int` | Preload trigger (default: 3) |
| `separator` | `Widget?` | Divider between items |
| `scrollController` | `ScrollController?` | Custom scroll controller |
| `shrinkWrap` | `bool` | Fit content size |
| `reverse` | `bool` | Reverse scroll direction |
| `canRefresh` | `bool` | Enable built-in pull-to-refresh (default: `false`) |
| `onRefresh` | `Future<void> Function(cubit)?` | Custom refresh callback (default: `cubit.reload()`) |

### Built-in Pull to Refresh

```dart
SuperPaginationListView.withProvider(
  request: const SuperPaginationRequest(page: 1, pageSize: 20),
  provider: SuperPaginationProvider<Product, SuperPaginationRequest>.future(fetchProducts),
  canRefresh: true,
  onRefresh: (cubit) async {
    cubit.reload();
  },
  itemBuilder: (context, items, index) => ProductTile(product: items[index]),
)
```

### State Builders

| Parameter | Description |
|-----------|-------------|-|
| `firstPageLoadingBuilder` | Initial loading widget |
| `firstPageErrorBuilder` | Initial error widget |
| `firstPageEmptyBuilder` | Empty state widget |
| `loadMoreLoadingBuilder` | Bottom loading indicator |
| `loadMoreErrorBuilder` | Pagination error widget |
| `loadMoreNoMoreItemsBuilder` | End of list widget |

---

## Cubit API

```dart
final cubit = SuperPaginationCubit<T, SuperPaginationRequest>({
  required SuperPaginationRequest request,
  required SuperPaginationProvider<T, SuperPaginationRequest> provider,
  RetryConfig? retryConfig,
  Duration? dataAge,
  int? maxPagesInMemory,
  SortOrderCollection<T>? orders,
});
```

### Properties

```dart
cubit.currentItems;   // List<T>
cubit.isDataExpired;  // bool
cubit.lastFetchTime;  // DateTime?
cubit.activeOrder;    // SortOrder<T>?
cubit.didFetch;       // bool
```

### Pagination Control

```dart
cubit.fetchPaginatedList();
cubit.refreshPaginatedList();
cubit.filterPaginatedList(test);
cubit.cancelOngoingRequest();
cubit.reload();
```

### Insert

| Method | Description |
|--------|-------------|-|
| `insertEmit(item, {index})` | Insert single item |
| `insertAllEmit(items, {index})` | Insert multiple items |
| `addOrUpdateEmit(item, {index})` | Add if new, update if exists |

### Remove

| Method | Description |
|--------|-------------|-|
| `removeItemEmit(item)` | Remove by value |
| `removeAtEmit(index)` | Remove at index |
| `removeWhereEmit(test)` | Remove all matching |
| `removeFirstWhereEmit(test)` | Remove first matching |
| `removeLastWhereEmit(test)` | Remove last matching |

### Update

| Method | Description |
|--------|-------------|-|
| `updateItemEmit(matcher, updater)` | Update first matching item |
| `updateWhereEmit(matcher, updater)` | Update all matching items |
| `updateFirstWhereEmit(matcher, updater)` | Update first matching item (explicit) |
| `updateLastWhereEmit(matcher, updater)` | Update last matching item |
| `updateAtEmit(index, updater)` | Update item at index |

### Replace

| Method | Description |
|--------|-------------|-|
| `replaceFirstWhereEmit(matcher, item)` | Replace first matching item |
| `replaceLastWhereEmit(matcher, item)` | Replace last matching item |
| `replaceAtEmit(index, item)` | Replace item at index |

### Refresh (async, re-fetches from server)

| Method | Description |
|--------|-------------|-|
| `refreshItem(matcher, refresher)` | Refresh first matching item |
| `refreshFirstWhereEmit(matcher, refresher)` | Refresh first matching item (explicit) |
| `refreshLastWhereEmit(matcher, refresher)` | Refresh last matching item |
| `refreshAtEmit(index, refresher)` | Refresh item at index |

### Bulk

| Method | Description |
|--------|-------------|-|
| `setItems(items)` | Replace entire list |
| `clearItems()` | Remove all items |

### Sorting

```dart
cubit.setActiveOrder(orderId);
cubit.resetOrder();
```

---

## Scroll Navigation

```dart
// Attach observer for precise navigation
cubit.attachListObserverController(observerController);

// Navigate
await cubit.animateToIndex(index, alignment: 0.5);
cubit.jumpToIndex(index);
await cubit.animateFirstWhere((item) => item.id == targetId);
cubit.jumpFirstWhere((item) => item.isUnread);
```

---

## Theming

### Pagination Theme

Use standard Flutter theming with custom loading/empty/error builders.

### Search Theme

```dart
MaterialApp(
  theme: ThemeData.light().copyWith(
    extensions: [SuperSearchTheme.light()],
  ),
  darkTheme: ThemeData.dark().copyWith(
    extensions: [SuperSearchTheme.dark()],
  ),
)
```

Custom theme:

```dart
SuperSearchTheme(
  searchBoxBackgroundColor: Colors.grey[100],
  searchBoxBorderRadius: BorderRadius.circular(12),
  overlayBackgroundColor: Colors.white,
  overlayElevation: 8,
  itemHoverColor: Colors.grey[100],
  itemFocusedColor: Colors.blue.withValues(alpha:0.1),
)
```

---

## Example App

The [example app](example/) preserves all existing demonstrations and typed
routes while using a feature-first Clean Architecture layout. Application
bootstrap, routing, theme control, domain entities, application contracts,
infrastructure adapters, controllers, and views are separated explicitly.
Legacy example paths remain available as compatibility exports.

```bash
cd example
flutter pub get
flutter run
```

The example includes pagination, stream, search, error-handling, and Firebase
integration demonstrations. See `example/ARCHITECTURE.md` for the dependency
rules and `example/REFACTORING_REPORT_AR.md` for the Arabic review.

## Best Practices

**1. Reuse cubits** - Create once in `initState`, dispose in `dispose`

**2. Use state separation** - Different UI for first-page vs load-more errors

**3. Configure preloading** - Adjust `invisibleItemsThreshold` for your scroll speed

**4. Set memory limits** - Use `maxPagesInMemory` for large datasets

**5. Use key-based selection** - For forms and state management in search dropdowns

---

## Resources

- [Error Handling Guide](docs/ERROR_HANDLING.md)
- [Error Images Setup](docs/ERROR_IMAGES_SETUP.md)
- [Changelog](CHANGELOG.md)
- [API Documentation](https://pub.dev/documentation/super_pagination/latest/)

---

## License

MIT License - see [LICENSE](LICENSE)

---

<div align="center">

**Transport agnostic** - Bring your own async function

Made by [Genius Systems](https://github.com/GeniusSystems24)

</div>
