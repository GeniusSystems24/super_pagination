# Migration Guide: 4.2.1 → 5.0.0

This guide covers the breaking and behavioral changes required to migrate `super_pagination` from **4.2.1** to **5.0.0**.

> This guide targets **5.0.0** specifically. Changes introduced later in **5.0.0+1** are intentionally not included.

---

## Overview

Version 5.0.0 introduces a more explicit pagination API with:

- six datasource modes
- typed pagination result models
- a dedicated cursor request type
- runtime request replacement through `setRequest`
- support for custom request subclasses
- nullable aggregate totals
- clearer separation between list, page, and cursor pagination

The main migration work is:

1. rename legacy datasource constructors
2. choose the appropriate datasource/result model
3. migrate cursor pagination to `SuperCursorPaginationRequest`
4. replace runtime datasource switching with request switching
5. update custom request subclasses so pagination state is preserved correctly

---

# 1. Datasource API changes

## 4.2.1

The primary datasource constructors were:

```dart
SuperPaginationDataSource.future(...)
SuperPaginationDataSource.stream(...)
SuperPaginationDataSource.mergeStreams(...)
```

The request/result contract was mostly list-oriented.

## 5.0.0

Version 5.0.0 introduces six explicit datasource modes:

```dart
SuperPaginationDataSource.listFuture(...)
SuperPaginationDataSource.listStream(...)

SuperPaginationDataSource.pageFuture(...)
SuperPaginationDataSource.pageStream(...)

SuperPaginationDataSource.cursorFuture(...)
SuperPaginationDataSource.cursorStream(...)
```

The legacy APIs remain available as deprecated compatibility aliases:

```dart
SuperPaginationDataSource.future(...)
SuperPaginationDataSource.stream(...)
```

`mergeStreams` is retained for compatibility.

---

# 2. Migrate `future` to `listFuture`

Before:

```dart
final dataSource = SuperPaginationDataSource.future(
  request: (request) async {
    return repository.getItems(
      page: request.page,
      pageSize: request.pageSize,
    );
  },
);
```

After:

```dart
final dataSource = SuperPaginationDataSource.listFuture(
  request: (request) async {
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
final dataSource = SuperPaginationDataSource.stream(
  request: (request) {
    return repository.watchItems(
      page: request.page,
      pageSize: request.pageSize,
    );
  },
);
```

After:

```dart
final dataSource = SuperPaginationDataSource.listStream(
  request: (request) {
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
SuperPaginationDataSource.pageFuture(...)
SuperPaginationDataSource.pageStream(...)
```

Example:

```dart
final dataSource = SuperPaginationDataSource.pageFuture<Item>(
  request: (request) async {
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
SuperPaginationDataSource.cursorFuture(...)
SuperPaginationDataSource.cursorStream(...)
```

Example:

```dart
final dataSource = SuperPaginationDataSource.cursorFuture<Item>(
  request: (request) async {
    final response = await api.getItems(
      cursor: request.cursorNo,
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
  dataSource: SuperPaginationDataSource.cursorFuture<Item>(
    request: (request) async {
      return repository.loadByCursor(
        cursorNo: request.cursorNo,
        pageSize: request.pageSize,
      );
    },
  ),
  initialRequest: const SuperCursorPaginationRequest(
    pageSize: 20,
  ),
);
```

The datasource result returns the next cursor through:

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

For typed page and cursor result modes, `hasMore` comes from the result returned by the datasource.

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

The datasource should remain fixed for the lifetime of the cubit.

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
    super.page,
    super.pageSize,
    super.filters,
    required this.workspaceId,
    this.status,
  });

  final String workspaceId;
  final String? status;

  @override
  CustomRequest copyWith({
    int? page,
    int? pageSize,
    Map<String, dynamic>? filters,
  }) {
    return CustomRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      filters: filters ?? this.filters,
      workspaceId: workspaceId,
      status: status,
    );
  }
}
```

Use it with any compatible datasource:

```dart
SuperPaginationDataSource.listFuture(...)
SuperPaginationDataSource.listStream(...)
SuperPaginationDataSource.pageFuture(...)
SuperPaginationDataSource.pageStream(...)
```

Example:

```dart
final cubit = SuperPaginationCubit<Item, CustomRequest>(
  dataSource: SuperPaginationDataSource.pageFuture<Item>(
    request: (request) async {
      return repository.loadPage(
        workspaceId: request.workspaceId,
        status: request.status,
        page: request.page,
        pageSize: request.pageSize,
      );
    },
  ),
  initialRequest: const CustomRequest(
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
    super.cursorNo,
    super.pageSize,
    super.filters,
    required this.workspaceId,
    this.status,
  });

  final String workspaceId;
  final String? status;

  @override
  CustomCursorRequest copyWith({
    int? pageSize,
    Map<String, dynamic>? filters,
  }) {
    return CustomCursorRequest(
      cursorNo: cursorNo,
      pageSize: pageSize ?? this.pageSize,
      filters: filters ?? this.filters,
      workspaceId: workspaceId,
      status: status,
    );
  }

  @override
  CustomCursorRequest copyWithCursor({
    int? cursorNo,
  }) {
    return CustomCursorRequest(
      cursorNo: cursorNo,
      pageSize: pageSize,
      filters: filters,
      workspaceId: workspaceId,
      status: status,
    );
  }
}
```

Use it with:

```dart
SuperPaginationDataSource.cursorFuture(...)
SuperPaginationDataSource.cursorStream(...)
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
  dataSource: SuperPaginationDataSource.future(
    request: (request) async {
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
  dataSource: SuperPaginationDataSource.listFuture(
    request: (request) async {
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
  dataSource: SuperPaginationDataSource.pageFuture(
    request: (request) async {
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
final dataSource = SuperPaginationDataSource.future(
  request: (request) async {
    return repository.load(
      cursor: request.filters['cursor'],
    );
  },
);
```

## After

```dart
final dataSource =
    SuperPaginationDataSource.cursorFuture<Item>(
  request: (request) async {
    final response = await repository.load(
      cursorNo: request.cursorNo,
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

# 14. Choosing the correct datasource

Use this mapping when migrating:

| Backend behavior | 5.0.0 datasource | Result |
|---|---|---|
| Future returning only items | `listFuture` | `List<T>` |
| Stream returning only items | `listStream` | `List<T>` |
| Future returning page metadata | `pageFuture` | `PagePaginationResult<T>` |
| Stream returning page metadata | `pageStream` | `PagePaginationResult<T>` |
| Future returning cursor metadata | `cursorFuture` | `CursorPaginationResult<T>` |
| Stream returning cursor metadata | `cursorStream` | `CursorPaginationResult<T>` |

If the API exposes an offset value, `OffsetPaginationResult<T>` is available as a result model, but 5.0.0 does not add separate offset datasource/request constructors.

---

# 15. Recommended migration sequence

1. Update the dependency to 5.0.0.

```yaml
dependencies:
  super_pagination: ^5.0.0
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

A common 4.x pattern was to rebuild or replace a datasource when filters changed.

In 5.0.0, keep the datasource fixed and change the request.

```dart
final cubit = SuperPaginationCubit<Item, CustomRequest>(
  dataSource: SuperPaginationDataSource.pageFuture(
    request: repository.loadItems,
  ),
  initialRequest: const CustomRequest(
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

The datasource stays unchanged while the request defines the new query state.

---

# 18. Compatibility notes

The following compatibility APIs remain available in 5.0.0:

```dart
SuperPaginationDataSource.future(...)
SuperPaginationDataSource.stream(...)
SuperPaginationDataSource.mergeStreams(...)
```

`future` and `stream` are deprecated aliases.

They can be used temporarily during migration, but new code should use the explicit datasource names.

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

- six datasource types
- typed result models
- cursor pagination
- runtime request switching
- custom page/list request subclasses
- custom cursor request subclasses

Use these examples as reference implementations when migrating application code.

---

# 20. Verification checklist

After migration, verify:

- [ ] package version is `5.0.0`
- [ ] legacy `.future(...)` usages are migrated to `.listFuture(...)` where appropriate
- [ ] legacy `.stream(...)` usages are migrated to `.listStream(...)` where appropriate
- [ ] page APIs use `PagePaginationResult` when server metadata is available
- [ ] cursor APIs use `SuperCursorPaginationRequest`
- [ ] cursor APIs return `CursorPaginationResult`
- [ ] `hasMore` comes from the server for typed result modes
- [ ] nullable `totalPages` is handled safely
- [ ] nullable `totalItems` is handled safely
- [ ] runtime datasource switching has been removed
- [ ] request/filter changes use `setRequest`
- [ ] custom requests preserve custom fields in `copyWith`
- [ ] custom cursor requests preserve custom fields in `copyWithCursor`
- [ ] refresh uses the expected current request
- [ ] load-more uses the expected current request
- [ ] examples compile
- [ ] tests pass
- [ ] `flutter analyze` reports no migration-related diagnostics

---

# 21. Final verification commands

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

The core architectural change in 5.0.0 is the move from a generic pagination datasource contract to explicit pagination modes.

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

This keeps datasource behavior stable while making pagination state, server metadata, and request evolution explicit.
