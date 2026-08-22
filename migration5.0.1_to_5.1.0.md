# Migration Guide: 5.0.1 → 5.1.0

This guide covers the changes required to migrate `super_pagination` from **5.0.1** to **5.1.0**.

Version 5.1.0 introduces two important capabilities:

- optional keep-alive behavior for pagination views
- `BuildContext` support in every pagination provider callback

The pagination model, result types, request switching behavior, and existing datasource modes remain conceptually unchanged.

---

# 1. Update the package version

Update your dependency:

```yaml
dependencies:
  super_pagination: ^5.1.0
```

Then run:

```bash
flutter pub get
```

---

# 2. Provider callbacks now receive `BuildContext`

## Before

In 5.0.1, provider callbacks receive only the request:

```dart
SuperPaginationProvider.listFuture(
  (request) async {
    return repository.fetch(request);
  },
)
```

## After

In 5.1.0, every provider callback receives:

```dart
(context, request)
```

Example:

```dart
SuperPaginationProvider.listFuture(
  (context, request) async {
    return repository.fetch(request);
  },
)
```

This applies to all provider modes.

---

# 3. Affected provider modes

Update callbacks for:

```dart
SuperPaginationProvider.listFuture(...)
SuperPaginationProvider.listStream(...)

SuperPaginationProvider.pageFuture(...)
SuperPaginationProvider.pageStream(...)

SuperPaginationProvider.cursorFuture(...)
SuperPaginationProvider.cursorStream(...)
```

Also update compatibility APIs if you still use them:

```dart
SuperPaginationProvider.future(...)
SuperPaginationProvider.stream(...)
SuperPaginationProvider.mergeStreams(...)
```

---

# 4. Why `BuildContext` was added

Provider implementations can now read dependencies directly from the widget tree.

For example:

```dart
SuperPaginationProvider.listFuture(
  (context, request) async {
    final repository = context.read<ProductRepository>();

    return repository.fetchProducts(
      page: request.page,
      pageSize: request.pageSize,
    );
  },
)
```

This works with dependency mechanisms that use `BuildContext`, such as:

```dart
context.read<T>()
context.watch<T>()
Provider.of<T>(context)
Theme.of(context)
Localizations.of(...)
```

For provider callbacks, prefer `context.read<T>()` for dependencies that should not rebuild the pagination widget.

---

# 5. Update inline callbacks

## Before

```dart
provider: SuperPaginationProvider.listFuture(
  (request) async {
    return api.fetchProducts(
      page: request.page,
      pageSize: request.pageSize,
    );
  },
),
```

## After

```dart
provider: SuperPaginationProvider.listFuture(
  (context, request) async {
    return api.fetchProducts(
      page: request.page,
      pageSize: request.pageSize,
    );
  },
),
```

If the callback does not need the context, use `_`:

```dart
provider: SuperPaginationProvider.listFuture(
  (_, request) async {
    return api.fetchProducts(request);
  },
),
```

---

# 6. Update method tear-offs

Method tear-offs that previously accepted only the request no longer match the provider signature.

## Before

```dart
Future<List<Product>> fetchProducts(
  SuperPaginationRequest request,
) async {
  // ...
}

final provider = SuperPaginationProvider.listFuture(
  fetchProducts,
);
```

This no longer matches:

```dart
Future<List<Product>> Function(
  BuildContext,
  SuperPaginationRequest,
)
```

## Option A — update the method signature

```dart
Future<List<Product>> fetchProducts(
  BuildContext context,
  SuperPaginationRequest request,
) async {
  final repository = context.read<ProductRepository>();
  return repository.fetch(request);
}

final provider = SuperPaginationProvider.listFuture(
  fetchProducts,
);
```

## Option B — wrap the existing method

If the method does not need context:

```dart
Future<List<Product>> fetchProducts(
  SuperPaginationRequest request,
) async {
  // ...
}

final provider = SuperPaginationProvider.listFuture(
  (_, request) => fetchProducts(request),
);
```

This is useful when migrating existing repository or service methods.

---

# 7. Update stream providers

## Before

```dart
provider: SuperPaginationProvider.listStream(
  (request) {
    return repository.watchProducts(request);
  },
),
```

## After

```dart
provider: SuperPaginationProvider.listStream(
  (context, request) {
    final repository = context.read<ProductRepository>();
    return repository.watchProducts(request);
  },
),
```

If you previously passed a stream-producing method directly:

```dart
provider: SuperPaginationProvider.listStream(
  repository.watchProducts,
),
```

wrap it:

```dart
provider: SuperPaginationProvider.listStream(
  (_, request) => repository.watchProducts(request),
),
```

---

# 8. Page result providers

## Before

```dart
provider: SuperPaginationProvider.pageFuture(
  (request) async {
    final response = await api.fetchPage(request);

    return PagePaginationResult<Product>(
      pageNumber: response.page,
      totalPages: response.totalPages,
      items: response.items,
      hasMore: response.hasMore,
    );
  },
),
```

## After

```dart
provider: SuperPaginationProvider.pageFuture(
  (context, request) async {
    final api = context.read<ProductApi>();
    final response = await api.fetchPage(request);

    return PagePaginationResult<Product>(
      pageNumber: response.page,
      totalPages: response.totalPages,
      items: response.items,
      hasMore: response.hasMore,
    );
  },
),
```

No changes are required to `PagePaginationResult`.

---

# 9. Cursor result providers

## Before

```dart
provider: SuperPaginationProvider.cursorFuture(
  (request) async {
    final response = await api.fetchByCursor(request);

    return CursorPaginationResult<Product>(
      lastCursorNo: response.lastCursorNo,
      totalItems: response.totalItems,
      items: response.items,
      hasMore: response.hasMore,
    );
  },
),
```

## After

```dart
provider: SuperPaginationProvider.cursorFuture(
  (context, request) async {
    final api = context.read<ProductApi>();
    final response = await api.fetchByCursor(request);

    return CursorPaginationResult<Product>(
      lastCursorNo: response.lastCursorNo,
      totalItems: response.totalItems,
      items: response.items,
      hasMore: response.hasMore,
    );
  },
),
```

`SuperCursorPaginationRequest` behavior is unchanged.

---

# 10. `mergeStreams` callbacks

If you use merged stream pagination, update any callback that previously receives only the request.

Before:

```dart
(request) => repository.watchPrimary(request)
```

After:

```dart
(context, request) =>
    context.read<ProductRepository>().watchPrimary(request)
```

Or, when context is not needed:

```dart
(_, request) => repository.watchPrimary(request)
```

Do not leave old one-argument callback tear-offs in merged stream definitions.

---

# 11. Direct `SuperPaginationCubit` usage

When `SuperPagination` creates or owns the cubit, the widget automatically supplies its current `BuildContext` to provider execution.

If you construct a `SuperPaginationCubit` directly and the provider needs inherited dependencies, provide a context explicitly.

Example:

```dart
final cubit = SuperPaginationCubit<Product, SuperPaginationRequest>(
  providerContext: context,
  request: const SuperPaginationRequest(
    page: 1,
    pageSize: 20,
  ),
  provider: SuperPaginationProvider.listFuture(
    (context, request) {
      final repository = context.read<ProductRepository>();
      return repository.fetch(request);
    },
  ),
);
```

If your provider does not use `BuildContext`, `providerContext` is not required.

---

# 12. Direct `SuperPaginationController.of(...)` usage

When creating pagination through `SuperPaginationController.of(...)`, pass `providerContext` when the provider needs context-dependent values.

Example:

```dart
final controller = SuperPaginationController.of<Product, SuperPaginationRequest>(
  providerContext: context,
  request: const SuperPaginationRequest(
    page: 1,
    pageSize: 20,
  ),
  provider: SuperPaginationProvider.listFuture(
    (context, request) {
      return context.read<ProductRepository>().fetch(request);
    },
  ),
);
```

Use the exact controller construction API available in your application if it wraps this helper.

---

# 13. Avoid storing `BuildContext` in your provider implementation

Provider callbacks receive the current context when the fetch is executed.

Do not persist it in long-lived objects.

Avoid:

```dart
BuildContext? savedContext;

provider: SuperPaginationProvider.listFuture(
  (context, request) async {
    savedContext = context;
    // ...
  },
),
```

Prefer reading the dependency immediately:

```dart
provider: SuperPaginationProvider.listFuture(
  (context, request) async {
    final repository = context.read<ProductRepository>();
    return repository.fetch(request);
  },
),
```

This keeps context ownership in the widget layer.

---

# 14. Avoid using `BuildContext` after an async gap

Flutter's analyzer reports:

```text
use_build_context_synchronously
```

when a `BuildContext` is used after `await` without validation.

Avoid:

```dart
provider: SuperPaginationProvider.listFuture(
  (context, request) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    final repository = context.read<ProductRepository>();

    return repository.fetch(request);
  },
),
```

Prefer resolving dependencies before the async gap:

```dart
provider: SuperPaginationProvider.listFuture(
  (context, request) async {
    final repository = context.read<ProductRepository>();

    await Future<void>.delayed(const Duration(seconds: 1));

    return repository.fetch(request);
  },
),
```

If you must use the context itself after an async operation, guard it:

```dart
provider: SuperPaginationProvider.listFuture(
  (context, request) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (!context.mounted) {
      return const <Product>[];
    }

    return context.read<ProductRepository>().fetch(request);
  },
),
```

Reading required dependencies before `await` is usually the cleaner approach.

---

# 15. New `keepAlive` field

Version 5.1.0 adds:

```dart
keepAlive
```

to `SuperPagination` and all public pagination view wrappers.

The default is:

```dart
keepAlive: false
```

This preserves the previous lifecycle behavior.

---

# 16. Basic `keepAlive` usage

```dart
SuperPaginationListView<Product, SuperPaginationRequest>.withProvider(
  keepAlive: true,
  request: const SuperPaginationRequest(
    page: 1,
    pageSize: 20,
  ),
  provider: SuperPaginationProvider.listFuture(
    (context, request) {
      return context.read<ProductRepository>().fetch(request);
    },
  ),
  itemBuilder: (context, items, index) {
    return ProductTile(items[index]);
  },
)
```

---

# 17. What `keepAlive: true` preserves

When the pagination view is hosted inside a lazy container that supports Flutter's automatic keep-alive protocol, enabling:

```dart
keepAlive: true
```

preserves the pagination widget's state while it is off-screen.

This includes:

- the same internally-created `SuperPaginationCubit`
- the same internal `ScrollController`
- loaded pagination items
- current request state
- current page/cursor state
- current scroll position

When the user returns to the tab/page, the pagination view continues from the retained state rather than being recreated.

---

# 18. Example with `TabBarView`

```dart
DefaultTabController(
  length: 2,
  child: Scaffold(
    appBar: AppBar(
      bottom: const TabBar(
        tabs: [
          Tab(text: 'Active'),
          Tab(text: 'Archived'),
        ],
      ),
    ),
    body: TabBarView(
      children: [
        SuperPaginationListView<Product, SuperPaginationRequest>.withProvider(
          keepAlive: true,
          request: const SuperPaginationRequest(
            page: 1,
            pageSize: 20,
            filters: {
              'status': 'active',
            },
          ),
          provider: SuperPaginationProvider.listFuture(
            (context, request) {
              return context
                  .read<ProductRepository>()
                  .fetch(request);
            },
          ),
          itemBuilder: (context, items, index) {
            return ProductTile(items[index]);
          },
        ),
        SuperPaginationListView<Product, SuperPaginationRequest>.withProvider(
          keepAlive: true,
          request: const SuperPaginationRequest(
            page: 1,
            pageSize: 20,
            filters: {
              'status': 'archived',
            },
          ),
          provider: SuperPaginationProvider.listFuture(
            (context, request) {
              return context
                  .read<ProductRepository>()
                  .fetch(request);
            },
          ),
          itemBuilder: (context, items, index) {
            return ProductTile(items[index]);
          },
        ),
      ],
    ),
  ),
)
```

Scroll one tab, switch to another, then return.

With `keepAlive: true`, the original pagination state and scroll position remain.

---

# 19. `keepAlive` is available on all pagination wrappers

The field is supported by:

```dart
SuperPagination
SuperPaginationListView
SuperPaginationGridView
SuperPaginationPageView
SuperPaginationStaggeredGridView
SuperPaginationColumn
SuperPaginationRow
SuperPaginationReorderableListView
```

Example:

```dart
SuperPaginationGridView<Product, SuperPaginationRequest>.withProvider(
  keepAlive: true,
  // ...
)
```

---

# 20. When to enable `keepAlive`

Use:

```dart
keepAlive: true
```

when:

- pagination is inside `TabBarView`
- pagination is inside `PageView`
- multiple tabs maintain independent pagination state
- users frequently switch between tabs
- preserving scroll position improves UX
- repeating initial network requests is undesirable

---

# 21. When to keep the default

Keep:

```dart
keepAlive: false
```

when:

- the pagination screen should reset when removed
- memory usage is more important than preserving tab state
- the parent does not support Flutter's keep-alive protocol
- the pagination view is short-lived
- reloading data when returning is intentional

---

# 22. `keepAlive` does not make widgets permanent

`keepAlive` participates in Flutter's `AutomaticKeepAlive` mechanism.

It does not prevent disposal when the widget is permanently removed from the widget tree.

For example, navigating away from a route and removing that route can still dispose the pagination state normally.

The behavior depends on the parent container honoring keep-alive requests.

---

# 23. Existing external cubits

If your application provides its own `SuperPaginationCubit`, `keepAlive` still controls whether the pagination widget state is retained by the parent.

However, an externally-owned cubit already has its own lifecycle.

`keepAlive` does not take ownership of an external cubit.

Make sure your application disposes externally-created cubits at the appropriate ownership boundary.

---

# 24. `setRequest` behavior is unchanged

The existing request-switching API remains:

```dart
cubit.setRequest(
  newRequest,
);
```

And:

```dart
cubit.setRequest(
  newRequest,
  fetch: false,
);
```

`keepAlive` does not change how requests are replaced.

When the view is retained, the latest active request remains part of the retained cubit state.

---

# 25. Refresh and load-more behavior is unchanged

Existing methods continue to work:

```dart
cubit.refreshPaginatedList();
cubit.fetchPaginatedList();
cubit.reload();
```

Provider execution now receives `BuildContext`, but pagination semantics remain the same.

Internally, the widget supplies the current context before provider execution.

---

# 26. Custom requests require no structural change

Existing request subclasses remain valid.

Example:

```dart
class CustomRequest extends SuperPaginationRequest {
  const CustomRequest({
    super.page,
    super.pageSize,
    super.filters,
    required this.workspaceId,
  });

  final String workspaceId;

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
    );
  }
}
```

Only the provider callback changes:

```dart
SuperPaginationProvider.pageFuture<Product, CustomRequest>(
  (context, request) async {
    final repository = context.read<ProductRepository>();

    return repository.fetchPage(
      workspaceId: request.workspaceId,
      request: request,
    );
  },
)
```

---

# 27. Custom cursor requests require no structural change

Existing custom cursor requests remain valid.

Only update the callback signature.

Before:

```dart
SuperPaginationProvider.cursorFuture(
  (request) => repository.fetchCursor(request),
)
```

After:

```dart
SuperPaginationProvider.cursorFuture(
  (context, request) {
    return context
        .read<ProductRepository>()
        .fetchCursor(request);
  },
)
```

`copyWithCursor` requirements remain unchanged.

---

# 28. Common migration error: one-argument inline callback

Error:

```text
The argument type
'Future<List<Product>> Function(SuperPaginationRequest)'
can't be assigned to the parameter type
'Future<List<Product>> Function(BuildContext, SuperPaginationRequest)'.
```

Fix:

```dart
(request) async {
```

to:

```dart
(context, request) async {
```

or:

```dart
(_, request) async {
```

---

# 29. Common migration error: method tear-off

Error:

```text
The argument type
'Stream<List<Product>> Function(SuperPaginationRequest)'
can't be assigned to the parameter type
'Stream<List<Product>> Function(BuildContext, SuperPaginationRequest)'.
```

Before:

```dart
provider: SuperPaginationProvider.listStream(
  repository.watchProducts,
),
```

After:

```dart
provider: SuperPaginationProvider.listStream(
  (_, request) => repository.watchProducts(request),
),
```

Or update the method itself to accept `BuildContext`.

---

# 30. Common migration warning: `use_build_context_synchronously`

If analyzer reports:

```text
Don't use 'BuildContext's across async gaps.
```

resolve inherited dependencies before `await`:

```dart
(context, request) async {
  final repository = context.read<ProductRepository>();

  final response = await repository.fetch(request);

  return response;
}
```

Do not silence the lint unless there is a specific justified reason.

---

# 31. Migration example: complete before/after

## 5.0.1

```dart
SuperPaginationListView<Product, SuperPaginationRequest>.withProvider(
  request: const SuperPaginationRequest(
    page: 1,
    pageSize: 20,
  ),
  provider: SuperPaginationProvider.listFuture(
    (request) async {
      return repository.fetchProducts(request);
    },
  ),
  itemBuilder: (context, items, index) {
    return ProductTile(items[index]);
  },
)
```

## 5.1.0

```dart
SuperPaginationListView<Product, SuperPaginationRequest>.withProvider(
  keepAlive: true,
  request: const SuperPaginationRequest(
    page: 1,
    pageSize: 20,
  ),
  provider: SuperPaginationProvider.listFuture(
    (context, request) async {
      final repository = context.read<ProductRepository>();
      return repository.fetchProducts(request);
    },
  ),
  itemBuilder: (context, items, index) {
    return ProductTile(items[index]);
  },
)
```

The two changes are:

```dart
keepAlive: true
```

when desired, and:

```dart
(context, request)
```

for provider callbacks.

---

# 32. Recommended migration sequence

1. update `super_pagination` to `^5.1.0`
2. search for all `SuperPaginationProvider` definitions
3. update every callback from `(request)` to `(context, request)`
4. update method tear-offs that still accept only the request
5. update `Future` providers
6. update `Stream` providers
7. update page-result providers
8. update cursor-result providers
9. update merged stream providers
10. update test providers
11. update example providers
12. update direct cubit usage with `providerContext` where context is required
13. resolve any `use_build_context_synchronously` diagnostics
14. add `keepAlive: true` where off-screen pagination state should survive
15. test tab/page switching and scroll restoration
16. run formatter, analyzer, and tests

---

# 33. Search patterns for migration

Useful searches:

```text
SuperPaginationProvider.
(request)
async (request)
Future<...> Function(SuperPaginationRequest)
Stream<...> Function(SuperPaginationRequest)
```

Also inspect method tear-offs manually.

For example:

```dart
SuperPaginationProvider.listFuture(repository.fetch)
```

may compile incorrectly after the callback type changes if `fetch` accepts only the request.

Replace it with:

```dart
SuperPaginationProvider.listFuture(
  (_, request) => repository.fetch(request),
)
```

---

# 34. Verification checklist

After migration, verify:

- [ ] package dependency is `super_pagination: ^5.1.0`
- [ ] every provider callback accepts `BuildContext` and request
- [ ] no maintained inline provider callbacks use only `(request)`
- [ ] no incompatible one-argument method tear-offs remain
- [ ] `listFuture` providers compile
- [ ] `listStream` providers compile
- [ ] `pageFuture` providers compile
- [ ] `pageStream` providers compile
- [ ] `cursorFuture` providers compile
- [ ] `cursorStream` providers compile
- [ ] compatibility `future` / `stream` callbacks are updated if still used
- [ ] merged stream callbacks are updated if used
- [ ] direct cubits receive `providerContext` when their providers require inherited values
- [ ] no `use_build_context_synchronously` warnings remain
- [ ] dependencies needed after an `await` are resolved before the async gap when possible
- [ ] `keepAlive` defaults to `false` where existing behavior should remain
- [ ] `keepAlive: true` is enabled only where state retention is desired
- [ ] tab/page switching preserves loaded data where expected
- [ ] tab/page switching preserves scroll position where expected
- [ ] externally-owned cubits still follow the application's intended lifecycle
- [ ] custom request pagination still preserves custom fields
- [ ] custom cursor pagination still preserves cursor and custom fields
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

If your project uses code generation, also run the appropriate generator before the final analyze/test pass.

---

# Summary

The 5.1.0 migration has two primary changes.

First, every `SuperPaginationProvider` callback now receives:

```dart
(context, request)
```

instead of:

```dart
(request)
```

This lets provider implementations resolve dependencies directly from the widget tree:

```dart
context.read<MyClass>()
```

Second, pagination views now support:

```dart
keepAlive: true
```

to preserve the same pagination state, internally-created cubit, internal scroll controller, loaded data, and scroll position while the view is retained off-screen by a keep-alive-aware parent.

Existing pagination requests, result models, `setRequest`, page pagination, cursor pagination, and custom request behavior otherwise remain unchanged.
