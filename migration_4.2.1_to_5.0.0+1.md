# Migration Guide: 4.2.1 → 5.0.0+1

This guide covers the complete migration of `super_pagination` from **4.2.1** through **5.0.0** and the **5.0.0+1** patch release.

> **5.0.0** introduces the new pagination architecture. **5.0.0+1** removes the legacy search dropdown feature family and cleans all related public API, examples, routes, theme registration, and tests.

> In 5.0.0 the public provider type is `SuperPaginationProvider`; there is no `SuperPaginationDataSource` API.

---

## Overview

Version 5.0.0 introduces a more explicit pagination API with:

- six provider modes
- typed pagination result models
- a dedicated cursor request type
- runtime request replacement through `setRequest`
- support for custom request subclasses
- nullable aggregate totals
- clearer separation between list, page, and cursor pagination

The main migration work is:

1. rename legacy provider constructors
2. choose the appropriate provider/result model
3. migrate cursor pagination to `SuperCursorPaginationRequest`
4. replace runtime provider switching with request switching
5. update custom request subclasses so pagination state is preserved correctly
6. remove all usage of the search dropdown APIs removed in 5.0.0+1
7. remove any app-specific routes, theme extensions, tests, or example wrappers that referenced those search components

---

# 1. Provider API changes

## 4.2.1

The primary provider constructors were:

```dart
SuperPaginationProvider.future(...)
SuperPaginationProvider.stream(...)
SuperPaginationProvider.mergeStreams(...)
```

The request/result contract was mostly list-oriented.

## 5.0.0

Version 5.0.0 introduces six explicit provider modes:

```dart
SuperPaginationProvider.listFuture(...)
SuperPaginationProvider.listStream(...)

SuperPaginationProvider.pageFuture(...)
SuperPaginationProvider.pageStream(...)

SuperPaginationProvider.cursorFuture(...)
SuperPaginationProvider.cursorStream(...)
```

The legacy APIs remain available as deprecated compatibility aliases:

```dart
SuperPaginationProvider.future(...)
SuperPaginationProvider.stream(...)
```

`mergeStreams` is retained for compatibility.

---

# 2. Migrate `future` to `listFuture`

Before:

```dart
final provider = SuperPaginationProvider.future(
  (request) async {
    return repository.getItems(
      page: request.page,
      pageSize: request.pageSize,
    );
  },
);
```

After:

```dart
final provider = SuperPaginationProvider.listFuture(
  (request) async {
    return repository.getItems(
      page: request.page,
      pageSize: request.pageSize,
    );
  },
);
```

Use `listFuture` when the backend returns only a list of items and the package should infer pagination behavior from the returned data.

---

# 3. Migrate `stream` to `listStream`

Before:

```dart
final provider = SuperPaginationProvider.stream(
  (request) {
    return repository.watchItems(
      page: request.page,
      pageSize: request.pageSize,
    );
  },
);
```

After:

```dart
final provider = SuperPaginationProvider.listStream(
  (request) {
    return repository.watchItems(
      page: request.page,
      pageSize: request.pageSize,
    );
  },
);
```

Use `listStream` when each request emits a list rather than server pagination metadata.

---

# 4. New typed result models

Version 5.0.0 adds explicit result classes for APIs that return pagination metadata.

## `PagePaginationResult<T>`

```dart
PagePaginationResult<T>(
  pageNumber: pageNumber,
  totalPages: totalPages,
  items: items,
  hasMore: hasMore,
)
```

Fields:

```dart
final int pageNumber;
final int? totalPages;
final List<T> items;
final bool hasMore;
```

Use it with:

```dart
SuperPaginationProvider.pageFuture(...)
SuperPaginationProvider.pageStream(...)
```

Example:

```dart
final provider = SuperPaginationProvider.pageFuture(
  (request) async {
    final response = await api.getItems(
      page: request.page,
      pageSize: request.pageSize,
    );

    return PagePaginationResult<Item>(
      pageNumber: response.page,
      totalPages: response.totalPages,
      items: response.items,
      hasMore: response.hasMore,
    );
  },
);
```

---

## `CursorPaginationResult<T>`

```dart
CursorPaginationResult<T>(
  lastCursorNo: lastCursorNo,
  totalItems: totalItems,
  items: items,
  hasMore: hasMore,
)
```

Fields:

```dart
final int? lastCursorNo;
final int? totalItems;
final List<T> items;
final bool hasMore;
```

Use it with:

```dart
SuperPaginationProvider.cursorFuture(...)
SuperPaginationProvider.cursorStream(...)
```

Example:

```dart
final provider = SuperPaginationProvider.cursorFuture(
  (request) async {
    final response = await api.getItems(
      lastCursorNo: request.lastCursorNo,
      limit: request.pageSize,
    );

    return CursorPaginationResult<Item>(
      lastCursorNo: response.lastCursorNo,
      totalItems: response.totalItems,
      items: response.items,
      hasMore: response.hasMore,
    );
  },
);
```

`lastCursorNo` is propagated automatically into the next cursor request.

---

## `OffsetPaginationResult<T>`

Version 5.0.0 also includes:

```dart
OffsetPaginationResult<T>(
  offset: offset,
  totalItems: totalItems,
  items: items,
  hasMore: hasMore,
)
```

Fields:

```dart
final int offset;
final int? totalItems;
final List<T> items;
final bool hasMore;
```

`OffsetPaginationResult` is available as a typed result model for integrations that expose offset metadata.

It does not introduce a separate `offsetFuture`, `offsetStream`, or offset-specific request type in 5.0.0.

---

# 5. `totalPages` and `totalItems` are nullable

Aggregate totals are optional in 5.0.0.

Before:

```dart
final int totalPages;
final int totalItems;
```

After:

```dart
final int? totalPages;
final int? totalItems;
```

This applies to:

```dart
PagePaginationResult.totalPages
CursorPaginationResult.totalItems
OffsetPaginationResult.totalItems
```

The constructor arguments remain required, so explicitly pass `null` when the backend does not provide the value:

```dart
return PagePaginationResult<Item>(
  pageNumber: response.page,
  totalPages: null,
  items: response.items,
  hasMore: response.hasMore,
);
```

---

# 6. Cursor pagination now uses `SuperCursorPaginationRequest`

Cursor pagination should no longer rely on the generic page request model.

Use:

```dart
SuperCursorPaginationRequest
```

Example:

```dart
final cubit = SuperPaginationCubit<Item, SuperCursorPaginationRequest>(
  provider: SuperPaginationProvider.cursorFuture(
    (request) async {
      return repository.loadByCursor(
        lastCursorNo: request.lastCursorNo,
        pageSize: request.pageSize,
      );
    },
  ),
  request: const SuperCursorPaginationRequest(
    pageSize: 20,
  ),
);
```

The provider result returns the next cursor through:

```dart
CursorPaginationResult(
  lastCursorNo: response.lastCursorNo,
  totalItems: response.totalItems,
  items: response.items,
  hasMore: response.hasMore,
)
```

The cubit carries `lastCursorNo` into subsequent requests automatically.

---

# 7. Server-controlled `hasMore`

For typed page and cursor result modes, `hasMore` comes from the result returned by the provider.

Example:

```dart
return PagePaginationResult<Item>(
  pageNumber: response.page,
  totalPages: response.totalPages,
  items: response.items,
  hasMore: response.hasMore,
);
```

Do not infer `hasMore` locally if the server already provides it.

This is especially important when:

- the last page can contain exactly `pageSize` items
- records are filtered after pagination
- the backend uses opaque pagination rules
- totals are unavailable

---

# 8. Replace `setSource` with `setRequest`

Runtime datasource switching is removed from the v5 API.

Do not use:

```dart
cubit.setSource(newSource);
```

The provider should remain fixed for the lifetime of the cubit.

Use:

```dart
cubit.setRequest(newRequest);
```

Example:

```dart
cubit.setRequest(
  const SuperPaginationRequest(
    pageSize: 20,
    filters: {
      'status': 'archived',
    },
  ),
);
```

By default this:

- cancels active pagination work
- replaces the active request
- resets pagination
- fetches the first page using the new request

To replace the active request without fetching immediately:

```dart
cubit.setRequest(
  newRequest,
  fetch: false,
);
```

---

# 9. The latest request persists across refreshes

In 5.0.0, the request supplied through `setRequest` becomes the cubit's active request.

Example:

```dart
cubit.setRequest(
  const SuperPaginationRequest(
    filters: {
      'status': 'active',
    },
  ),
);

await cubit.refreshPaginatedList();
```

The refresh continues using the `status = active` request.

It does not revert to the original constructor request.

You can inspect the current request through:

```dart
final request = cubit.currentRequest;
```

---

# 10. Custom requests

Version 5.0.0 supports custom request classes.

## Page/list custom request

```dart
class CustomRequest extends SuperPaginationRequest {
  const CustomRequest({
    super.page = 1,
    super.pageSize,
    super.filters,
    super.extra,
    super.searchQuery,
    required this.workspaceId,
    this.status,
  });

  final String workspaceId;
  final String? status;

  @override
  CustomRequest copyWith({
    int? page,
    int? pageSize,
    String? cursor,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? extra,
    String? searchQuery,
  }) {
    return CustomRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      filters: filters ?? this.filters,
      extra: extra ?? this.extra,
      searchQuery: searchQuery ?? this.searchQuery,
      workspaceId: workspaceId,
      status: status,
    );
  }
}
```

Use it with any compatible provider mode:

```dart
SuperPaginationProvider.listFuture(...)
SuperPaginationProvider.listStream(...)
SuperPaginationProvider.pageFuture(...)
SuperPaginationProvider.pageStream(...)
```

Example:

```dart
final cubit = SuperPaginationCubit<Item, CustomRequest>(
  provider: SuperPaginationProvider.pageFuture(
    (request) async {
      return repository.loadPage(
        workspaceId: request.workspaceId,
        status: request.status,
        page: request.page,
        pageSize: request.pageSize,
      );
    },
  ),
  request: const CustomRequest(
    workspaceId: 'workspace-1',
    pageSize: 20,
  ),
);
```

### Important

The overridden `copyWith` must preserve your custom fields.

Incorrect:

```dart
@override
CustomRequest copyWith({
  int? page,
  int? pageSize,
  Map<String, dynamic>? filters,
}) {
  return CustomRequest(
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    workspaceId: '',
  );
}
```

Correct:

```dart
workspaceId: workspaceId,
status: status,
```

Otherwise custom state can be lost during pagination.

---

# 11. Custom cursor requests

For cursor pagination, extend:

```dart
SuperCursorPaginationRequest
```

Example:

```dart
class CustomCursorRequest extends SuperCursorPaginationRequest {
  const CustomCursorRequest({
    super.page = 1,
    super.pageSize,
    super.lastCursorNo,
    super.filters,
    super.extra,
    super.searchQuery,
    required this.workspaceId,
    this.status,
  });

  final String workspaceId;
  final String? status;

  @override
  CustomCursorRequest copyWith({
    int? page,
    int? pageSize,
    String? cursor,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? extra,
    String? searchQuery,
  }) {
    return CustomCursorRequest(
      page: page ?? this.page,
      lastCursorNo: lastCursorNo,
      pageSize: pageSize ?? this.pageSize,
      filters: filters ?? this.filters,
      extra: extra ?? this.extra,
      searchQuery: searchQuery ?? this.searchQuery,
      workspaceId: workspaceId,
      status: status,
    );
  }

  @override
  CustomCursorRequest copyWithCursor({
    int? page,
    int? pageSize,
    int? lastCursorNo,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? extra,
    String? searchQuery,
  }) {
    return CustomCursorRequest(
      page: page ?? this.page,
      lastCursorNo: lastCursorNo ?? this.lastCursorNo,
      pageSize: pageSize ?? this.pageSize,
      filters: filters ?? this.filters,
      extra: extra ?? this.extra,
      searchQuery: searchQuery ?? this.searchQuery,
      workspaceId: workspaceId,
      status: status,
    );
  }
}
```

Use it with:

```dart
SuperPaginationProvider.cursorFuture(...)
SuperPaginationProvider.cursorStream(...)
```

### Important

Cursor request subclasses should preserve custom fields in both:

```dart
copyWith(...)
copyWithCursor(...)
```

---

# 12. Example: migrate page pagination

## 4.2.1

```dart
final cubit = SuperPaginationCubit<Item>(
  provider: SuperPaginationProvider.future(
    (request) async {
      return api.getItems(
        page: request.page,
        pageSize: request.pageSize,
      );
    },
  ),
);
```

## 5.0.0 — list result

If the API only returns items:

```dart
final cubit = SuperPaginationCubit<Item>(
  provider: SuperPaginationProvider.listFuture(
    (request) async {
      return api.getItems(
        page: request.page,
        pageSize: request.pageSize,
      );
    },
  ),
);
```

## 5.0.0 — typed page result

If the API returns pagination metadata:

```dart
final cubit = SuperPaginationCubit<Item>(
  provider: SuperPaginationProvider.pageFuture(
    (request) async {
      final response = await api.getItems(
        page: request.page,
        pageSize: request.pageSize,
      );

      return PagePaginationResult<Item>(
        pageNumber: response.page,
        totalPages: response.totalPages,
        items: response.items,
        hasMore: response.hasMore,
      );
    },
  ),
);
```

Prefer the typed result form when the backend already provides authoritative pagination metadata.

---

# 13. Example: migrate cursor pagination

## Before

Cursor state may have been carried through the generic request fields or custom filters.

```dart
final provider = SuperPaginationProvider.future(
  (request) async {
    return repository.load(
      cursor: request.filters['cursor'],
    );
  },
);
```

## After

```dart
final provider =
    SuperPaginationProvider.cursorFuture(
  (request) async {
    final response = await repository.load(
      lastCursorNo: request.lastCursorNo,
      pageSize: request.pageSize,
    );

    return CursorPaginationResult<Item>(
      lastCursorNo: response.lastCursorNo,
      totalItems: response.totalItems,
      items: response.items,
      hasMore: response.hasMore,
    );
  },
);
```

Initial request:

```dart
const SuperCursorPaginationRequest(
  pageSize: 20,
)
```

This removes the need to manually store the next cursor in filters.

---

# 14. Choosing the correct provider mode

Use this mapping when migrating:

| Backend behavior | 5.0.0 provider | Result |
|---|---|---|
| Future returning only items | `listFuture` | `List<T>` |
| Stream returning only items | `listStream` | `List<T>` |
| Future returning page metadata | `pageFuture` | `PagePaginationResult<T>` |
| Stream returning page metadata | `pageStream` | `PagePaginationResult<T>` |
| Future returning cursor metadata | `cursorFuture` | `CursorPaginationResult<T>` |
| Stream returning cursor metadata | `cursorStream` | `CursorPaginationResult<T>` |

If the API exposes an offset value, `OffsetPaginationResult<T>` is available as a result model, but 5.0.0 does not add separate offset provider/request constructors.

---

# 15. Recommended migration sequence

1. Update the dependency to 5.0.0+1.

```yaml
dependencies:
  super_pagination: ^5.0.0+1
```

2. Replace:

```dart
.future(...)
```

with:

```dart
.listFuture(...)
```

3. Replace:

```dart
.stream(...)
```

with:

```dart
.listStream(...)
```

4. For APIs that return page metadata, migrate to:

```dart
pageFuture
pageStream
PagePaginationResult
```

5. For cursor APIs, migrate to:

```dart
SuperCursorPaginationRequest
cursorFuture
cursorStream
CursorPaginationResult
```

6. Replace runtime `setSource` logic with:

```dart
setRequest(...)
```

7. Update custom request classes to preserve custom fields in `copyWith`.

8. For custom cursor requests, also implement `copyWithCursor`.

9. Update code that assumes totals are always available.

10. Run formatter, analyzer, and tests.

---

# 16. Nullable total migration

Code like this may need updating:

```dart
Text('${result.totalPages}')
```

This still renders, but may display `null`.

Prefer:

```dart
if (result.totalPages != null)
  Text('${result.totalPages}')
```

or:

```dart
Text(
  result.totalPages?.toString() ?? 'Unknown',
)
```

For calculations, handle the null case explicitly.

Before:

```dart
final remaining = result.totalItems - loadedItems.length;
```

After:

```dart
final remaining = result.totalItems == null
    ? null
    : result.totalItems! - loadedItems.length;
```

Do not replace an unknown server total with `0` unless `0` is semantically correct.

---

# 17. Request switching example

A common 4.x pattern was to rebuild or replace a provider when filters changed.

In 5.0.0, keep the provider fixed and change the request.

```dart
final cubit = SuperPaginationCubit<Item, CustomRequest>(
  provider: SuperPaginationProvider.pageFuture(
    repository.loadItems,
  ),
  request: const CustomRequest(
    workspaceId: 'main',
    status: 'active',
  ),
);
```

Later:

```dart
cubit.setRequest(
  const CustomRequest(
    workspaceId: 'main',
    status: 'archived',
  ),
);
```

The provider stays unchanged while the request defines the new query state.

---

# 18. Compatibility notes

The following compatibility APIs remain available in 5.0.0:

```dart
SuperPaginationProvider.future(...)
SuperPaginationProvider.stream(...)
SuperPaginationProvider.mergeStreams(...)
```

`future` and `stream` are deprecated aliases.

They can be used temporarily during migration, but new code should use the explicit provider names.

Recommended:

```dart
listFuture
listStream
pageFuture
pageStream
cursorFuture
cursorStream
```

---

# 19. Example screens added in 5.0.0

The package examples include dedicated coverage for the new API, including:

- six provider modes
- typed result models
- cursor pagination
- runtime request switching
- custom page/list request subclasses
- custom cursor request subclasses

Use these examples as reference implementations when migrating application code.

---


# 20. Changes in 5.0.0+1

Version **5.0.0+1** is a cleanup release built on top of the 5.0.0 pagination architecture.

The main change is the complete removal of the old search dropdown feature family.

## Removed public widgets

The following widgets are removed:

```dart
SuperSearchDropdown
SuperSearchMultiDropdown
```

Any application code importing or constructing these widgets must be removed or migrated to an application-owned search/select implementation.

There is no compatibility alias for these APIs in 5.0.0+1.

---

# 21. Removed search dropdown support classes

All components that existed specifically to support the removed search dropdown widgets are also removed.

This includes the search feature's:

- controllers
- multi-selection controllers
- search box widgets
- overlay widgets
- search theme extension
- configuration models
- search-specific enums
- overlay positioning utilities
- helper classes used only by the dropdown feature

In particular, code should no longer reference:

```dart
SuperSearchController
SuperSearchMultiController
SuperSearchBox
SuperSearchOverlay
SuperSearchTheme
```

If your application imported internal search files directly, those imports must also be removed.

---

# 22. Remove search feature imports

Before 5.0.0+1, application code may have imported the search APIs through the package barrel.

For example:

```dart
import 'package:super_pagination/super_pagination.dart';

final field = SuperSearchDropdown(...);
```

After upgrading, remove all use of the removed search classes:

```dart
import 'package:super_pagination/super_pagination.dart';

// Use only pagination APIs that remain part of super_pagination.
```

If you used direct `src/.../search/...` imports, remove them as well.

Direct imports into package `src` were never recommended and will no longer resolve after this cleanup.

---

# 23. Replace `SuperSearchDropdown`

There is no direct replacement inside `super_pagination` 5.0.0+1.

Before:

```dart
SuperSearchDropdown<Item>(
  items: items,
  onChanged: (item) {
    // ...
  },
)
```

After:

```dart
// Move search/select UI to the application layer or another dedicated
// form/search package. Keep super_pagination responsible for pagination.
```

If the removed dropdown was only being used to update pagination filters, keep the selection UI separate and pass the selected value into the cubit request:

```dart
cubit.setRequest(
  cubit.currentRequest.copyWith(
    filters: {
      ...cubit.currentRequest.filters,
      'status': selectedStatus,
    },
  ),
);
```

Recommended responsibility flow:

```text
search/select UI
        ↓
build/update request
        ↓
SuperPaginationCubit.setRequest(...)
        ↓
SuperPaginationProvider
```

---

# 24. Replace `SuperSearchMultiDropdown`

There is also no direct replacement inside `super_pagination`.

Before:

```dart
SuperSearchMultiDropdown<Item>(
  items: items,
  onChanged: (items) {
    // ...
  },
)
```

After, manage multi-selection outside the pagination package and convert the selection into request data.

Example:

```dart
void applySelectedStatuses(List<String> statuses) {
  cubit.setRequest(
    cubit.currentRequest.copyWith(
      filters: {
        ...cubit.currentRequest.filters,
        'statuses': statuses,
      },
    ),
  );
}
```

This keeps selection state and pagination state separate.

---

# 25. `SuperSearchTheme` is removed

`SuperSearchTheme` was tied to the removed search feature and is no longer part of the package.

Remove registrations such as:

```dart
ThemeData(
  extensions: const [
    SuperSearchTheme(
      // ...
    ),
  ],
)
```

After:

```dart
ThemeData(
  extensions: const [
    // Keep only theme extensions that still exist.
  ],
)
```

Also remove:

- `SuperSearchTheme.of(context)`
- `Theme.of(context).extension<SuperSearchTheme>()`
- tests that assert `SuperSearchTheme` is installed
- custom theme-copy helpers that reference it

---

# 26. Example screens removed in 5.0.0+1

All example screens dedicated to the removed search dropdown APIs are removed.

This includes:

- `SuperSearchDropdown` examples
- `SuperSearchMultiDropdown` examples
- compatibility wrapper/export screens for those examples
- the Firestore search example that depended on `SuperSearchDropdown`

Do not keep imports to removed example files in:

- `example/lib`
- route configuration
- generated router files
- home/dashboard example lists
- sidebar navigation
- tests

The normal pagination filtering/search example remains valid when it only updates `SuperPaginationRequest` and does not use the removed dropdown widgets.

---

# 27. Example navigation and route cleanup

If your application copied the package example architecture, remove stale search routes.

For example, remove code such as:

```dart
AppRoutes.search
```

and any corresponding router entry.

Also remove search-specific section roots or module mappings, for example:

```dart
AppRoutes.search
'module-search'
```

A stale route reference can produce diagnostics such as:

```text
The getter 'search' isn't defined for the type 'AppRoutes'.
```

It can also cause secondary const-expression errors when the undefined route is used inside a const set or list.

After deleting the search route, update any navigation tests to use a route that still exists.

---

# 28. Generated router cleanup

When using GoRouter code generation or generated route files:

1. remove the source route declarations for deleted search examples
2. regenerate router output if your project uses code generation
3. verify that generated files contain no references to removed search screens

Typical verification command when using `build_runner`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Use the generation command appropriate for your project.

---

# 29. Sidebar and home-screen cleanup

Applications that copied the package example navigation should remove the Search module/category from:

- sidebar entries
- navigation destinations
- home-screen cards
- module registries
- route-to-module mapping
- selected-index calculations

If the Search category occupied an index between other categories, adjust the remaining indices.

For example, if the old ordering was:

```text
0 Pagination
1 Errors
2 Search
3 Custom
```

after removing Search it becomes:

```text
0 Pagination
1 Errors
2 Custom
```

Any hard-coded index that still assumes the old position must be updated.

---

# 30. Test cleanup for 5.0.0+1

Remove or update tests that reference any deleted search API.

Examples of obsolete assertions:

```dart
expect(
  Theme.of(context).extension<SuperSearchTheme>(),
  isNotNull,
);
```

and:

```dart
expect(AppRoutes.search, ...);
```

Also remove widget tests that instantiate:

```dart
SuperSearchDropdown
SuperSearchMultiDropdown
```

Navigation tests should target routes that still exist.

---

# 31. Package architecture after 5.0.0+1

After the patch, `super_pagination` has a clearer responsibility boundary.

The package focuses on:

- pagination requests
- pagination providers
- pagination cubits/state
- list/page/cursor pagination
- pagination result metadata
- request switching
- pagination-specific error and presentation behavior

The package no longer owns generic searchable dropdown/select UI.

This reduces coupling between pagination infrastructure and form/search controls.

---

# 32. Direct migration from 4.2.1 to 5.0.0+1

If you are upgrading directly from 4.2.1, perform the migration in this order:

1. update the dependency to `^5.0.0+1`
2. migrate `future` to `listFuture`
3. migrate `stream` to `listStream`
4. migrate page-aware APIs to `pageFuture` / `pageStream`
5. migrate cursor APIs to `SuperCursorPaginationRequest`
6. return `CursorPaginationResult` from cursor providers
7. adopt nullable `totalPages` / `totalItems`
8. replace provider switching with `setRequest`
9. update custom `SuperPaginationRequest` subclasses
10. update custom `SuperCursorPaginationRequest` subclasses
11. remove `SuperSearchDropdown`
12. remove `SuperSearchMultiDropdown`
13. remove search controllers, overlay, config, theme, and helper usages
14. remove deleted search example imports and routes
15. remove `AppRoutes.search` and search module mappings
16. remove `SuperSearchTheme` from application themes and tests
17. regenerate router output if applicable
18. run formatter, analyzer, and tests

---

# 33. 5.0.0+1 migration checklist

After upgrading to 5.0.0+1, verify:

- [ ] dependency is `super_pagination: ^5.0.0+1`
- [ ] no `SuperSearchDropdown` references remain
- [ ] no `SuperSearchMultiDropdown` references remain
- [ ] no `SuperSearchController` references remain
- [ ] no `SuperSearchMultiController` references remain
- [ ] no `SuperSearchBox` references remain
- [ ] no `SuperSearchOverlay` references remain
- [ ] no `SuperSearchTheme` references remain
- [ ] no direct imports of removed search feature files remain
- [ ] no removed search example imports remain
- [ ] no search example routes remain
- [ ] no `AppRoutes.search` references remain
- [ ] no `module-search` mappings remain
- [ ] sidebar/home navigation no longer contains the Search module
- [ ] navigation indices are correct after removing Search
- [ ] theme-extension tests no longer assert `SuperSearchTheme`
- [ ] navigation tests use existing routes
- [ ] generated router output contains no removed search routes
- [ ] pagination filter/search examples that remain do not depend on removed dropdown APIs
- [ ] `flutter analyze` reports no stale search-related diagnostics
- [ ] all tests pass

---

# 34. Complete verification checklist

After migration, verify:

- [ ] package version is `5.0.0+1`
- [ ] legacy `.future(...)` usages are migrated to `.listFuture(...)` where appropriate
- [ ] legacy `.stream(...)` usages are migrated to `.listStream(...)` where appropriate
- [ ] page APIs use `PagePaginationResult` when server metadata is available
- [ ] cursor APIs use `SuperCursorPaginationRequest`
- [ ] cursor APIs return `CursorPaginationResult`
- [ ] `hasMore` comes from the server for typed result modes
- [ ] nullable `totalPages` is handled safely
- [ ] nullable `totalItems` is handled safely
- [ ] runtime provider switching has been removed
- [ ] request/filter changes use `setRequest`
- [ ] custom requests preserve custom fields in `copyWith`
- [ ] custom cursor requests preserve custom fields in `copyWithCursor`
- [ ] refresh uses the expected current request
- [ ] load-more uses the expected current request
- [ ] examples compile
- [ ] tests pass
- [ ] `flutter analyze` reports no migration-related diagnostics

---

# 35. Final verification commands

Run:

```bash
dart format .
flutter analyze
flutter test
```

For the example application:

```bash
cd example
flutter pub get
flutter analyze
flutter test
```

---

## Summary

The migration from 4.2.1 to 5.0.0+1 has two major parts:

1. **5.0.0** moves pagination to explicit provider modes, typed result data, dedicated cursor requests, request switching, and custom request support.
2. **5.0.0+1** removes the complete `SuperSearchDropdown` / `SuperSearchMultiDropdown` feature family and all supporting search-specific API.

The core architectural change in 5.0.0 is the move from a generic pagination provider contract to explicit pagination modes.

Prefer:

```dart
listFuture / listStream
pageFuture / pageStream
cursorFuture / cursorStream
```

Use typed server results when metadata is available:

```dart
PagePaginationResult
CursorPaginationResult
OffsetPaginationResult
```

Use:

```dart
SuperCursorPaginationRequest
```

for cursor pagination, and use:

```dart
cubit.setRequest(...)
```

when filters or query parameters change.

This keeps provider behavior stable while making pagination state, server metadata, and request evolution explicit.


For 5.0.0+1, searchable dropdown/select UI should live outside `super_pagination`. Use that UI to construct or update a pagination request, then apply it through `SuperPaginationCubit.setRequest(...)`.
