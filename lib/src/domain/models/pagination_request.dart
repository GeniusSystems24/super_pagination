
/// Lightweight request descriptor used by the pagination cubit.
///
/// [SuperPaginationRequest] is the page/offset request model. For cursor based
/// APIs use [SuperCursorPaginationRequest], introduced in v5.
class SuperPaginationRequest {
  const SuperPaginationRequest({
    this.page = 1,
    this.pageSize,
    @Deprecated('Use SuperCursorPaginationRequest.lastCursorNo in v5.')
    this.cursor,
    this.filters,
    this.extra,
    this.searchQuery,
  }) : assert(page > 0, 'Page must be greater than 0');

  /// Current page (1-based). Cursor requests also use this as an internal
  /// ordinal so page-scoped stream caching remains deterministic.
  final int page;

  /// Number of items requested per page.
  final int? pageSize;

  /// Legacy string cursor kept for source compatibility with v4.
  @Deprecated('Use SuperCursorPaginationRequest.lastCursorNo in v5.')
  final String? cursor;

  /// Optional filter payload forwarded to the datasource.
  final Map<String, dynamic>? filters;

  /// Bag for additional metadata callers want to persist.
  final Map<String, dynamic>? extra;

  /// Optional search query string.
  final String? searchQuery;

  /// Creates a copy with the supplied fields replaced.
  ///
  /// Custom subclasses must override this and return their own concrete type.
  SuperPaginationRequest copyWith({
    int? page,
    int? pageSize,
    String? cursor,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? extra,
    String? searchQuery,
  }) {
    return SuperPaginationRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      cursor: cursor ?? this.cursor,
      filters: filters ?? this.filters,
      extra: extra ?? this.extra,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Cursor-aware request introduced in v5.
///
/// [lastCursorNo] is advanced automatically by [SuperPaginationCubit] whenever
/// a cursor datasource returns [CursorPaginationResult.lastCursorNo].
class SuperCursorPaginationRequest extends SuperPaginationRequest {
  const SuperCursorPaginationRequest({
    super.page = 1,
    super.pageSize,
    this.lastCursorNo,
    super.filters,
    super.extra,
    super.searchQuery,
  });

  /// Last cursor number received from the backend, or `null` for the first
  /// request.
  final int? lastCursorNo;

  @override
  SuperCursorPaginationRequest copyWith({
    int? page,
    int? pageSize,
    String? cursor,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? extra,
    String? searchQuery,
  }) {
    return SuperCursorPaginationRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      lastCursorNo: lastCursorNo,
      filters: filters ?? this.filters,
      extra: extra ?? this.extra,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Cursor-specific copy operation used internally by the cubit.
  ///
  /// Custom cursor request subclasses should override this method covariantly
  /// if they add required fields, in the same way they override [copyWith].
  SuperCursorPaginationRequest copyWithCursor({
    int? page,
    int? pageSize,
    int? lastCursorNo,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? extra,
    String? searchQuery,
  }) {
    return SuperCursorPaginationRequest(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      lastCursorNo: lastCursorNo ?? this.lastCursorNo,
      filters: filters ?? this.filters,
      extra: extra ?? this.extra,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
