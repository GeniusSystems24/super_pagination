
/// Base contract for server-aware pagination results.
///
/// Unlike raw-list datasources, result datasources carry an explicit [hasMore]
/// value from the backend so the cubit never needs to infer end-of-pagination
/// from the returned item count.
sealed class PaginationResultData<T> {
  const PaginationResultData({required this.items, required this.hasMore});

  final List<T> items;
  final bool hasMore;
}

/// Result returned by a page-number based datasource.
final class PagePaginationResult<T> extends PaginationResultData<T> {
  const PagePaginationResult({
    required this.pageNumber,
    this.totalPages,
    required super.items,
    required super.hasMore,
  });

  /// 1-based page number represented by [items].
  final int pageNumber;

  /// Total page count reported by the backend.
  final int? totalPages;
}

/// Result returned by an offset based datasource.
///
/// [offset] is the zero-based offset represented by [items]. [totalItems]
/// contains the backend-reported total item count, while [hasMore] remains
/// authoritative for deciding whether another result segment exists.
final class OffsetPaginationResult<T> extends PaginationResultData<T> {
  const OffsetPaginationResult({
    required this.offset,
    this.totalItems,
    required super.items,
    required super.hasMore,
  });

  /// Zero-based offset represented by [items].
  final int offset;

  /// Total item count reported by the backend.
  final int? totalItems;
}

/// Result returned by a cursor based datasource.
final class CursorPaginationResult<T> extends PaginationResultData<T> {
  const CursorPaginationResult({
    required this.lastCursorNo,
    this.totalItems,
    required super.items,
    required super.hasMore,
  });

  /// Cursor number that must be sent with the next request.
  ///
  /// `null` is valid for an empty dataset or a backend that does not expose a
  /// continuation cursor after the last response.
  final int? lastCursorNo;

  /// Total item count reported by the backend.
  final int? totalItems;
}
