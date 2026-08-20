
# Super Pagination v5 Skill

Use this package for paginated Flutter lists, grids, page views, and realtime streams.

## v5 source selection

Choose exactly one of the six canonical datasource modes:

- `SuperPaginationProvider.listFuture` for `Future<List<T>>` APIs.
- `SuperPaginationProvider.listStream` for `Stream<List<T>>` APIs.
- `SuperPaginationProvider.pageFuture` for `Future<PagePaginationResult<T>>` APIs.
- `SuperPaginationProvider.pageStream` for `Stream<PagePaginationResult<T>>` APIs.
- `SuperPaginationProvider.cursorFuture` for `Future<CursorPaginationResult<T>>` APIs.
- `SuperPaginationProvider.cursorStream` for `Stream<CursorPaginationResult<T>>` APIs.

`mergeStreams` is retained as a compatibility utility for merging multiple raw
list streams. `future` and `stream` are deprecated aliases for `listFuture` and
`listStream`.

## Page result contract

```dart
PagePaginationResult<T>(
  pageNumber: response.page,
  totalPages: response.totalPages,
  items: response.items,
  hasMore: response.hasMore,
)
```

Use `SuperPaginationRequest(page: 1, pageSize: ...)` with page-result sources.
The cubit treats `hasMore` as authoritative.

## Offset result contract

```dart
OffsetPaginationResult<T>(
  offset: response.offset,
  totalItems: response.totalItems,
  items: response.items,
  hasMore: response.hasMore,
)
```

Use this model when an integration needs to represent offset-based response
metadata. It is a ResultData model only; it does not add another provider
factory or a dedicated request type.

## Cursor result contract

```dart
CursorPaginationResult<T>(
  lastCursorNo: response.lastCursorNo,
  totalItems: response.totalItems,
  items: response.items,
  hasMore: response.hasMore,
)
```

Use `SuperCursorPaginationRequest(pageSize: ...)`. The cubit automatically
copies `lastCursorNo` from each successful result into the next request.

## Runtime request replacement

Keep the datasource fixed after cubit construction. Put filters, search terms,
tenant IDs, tab scopes, and similar runtime query state in the request, then use
`cubit.setRequest(nextRequest)`. The cubit cancels in-flight work and old page
streams, resets to page 1, stores `nextRequest` as the active request, and loads
it. Future refreshes and load-more calls continue from that active request.
Pass `fetch: false` when the caller wants to update/reset the request without
fetching immediately.

## Migration rules

Prefer `listFuture`/`listStream` in new code. Move APIs that already return page
or cursor metadata to the corresponding ResultData source so end-of-list is
server-driven rather than inferred from item count. Do not use cursor sources
with a plain `SuperPaginationRequest`; use `SuperCursorPaginationRequest` or a
subclass that preserves `lastCursorNo` in its copy methods.

## Removed search dropdown APIs

As of `5.0.1`, do not use or recommend `SuperSearchDropdown`, `SuperSearchMultiDropdown`, or their former search controllers, overlays, configuration objects, or `SuperSearchTheme`. The package public surface is focused on pagination data sources, requests, results, cubits, and pagination views.
