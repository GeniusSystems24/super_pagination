
/// Metadata describing the state of a paginated response.
class SuperPaginationMeta {
  SuperPaginationMeta({
    this.page,
    this.pageSize,
    this.nextCursor,
    this.previousCursor,
    this.lastCursorNo,
    this.totalPages,
    this.hasNext = false,
    this.hasPrevious = false,
    this.totalCount,
    DateTime? fetchedAt,
  }) : fetchedAt = fetchedAt ?? DateTime.now();

  final int? page;
  final int? pageSize;

  /// Legacy string cursor metadata retained for v4 compatibility.
  final String? nextCursor;
  final String? previousCursor;

  /// Numeric cursor returned by a v5 cursor datasource.
  final int? lastCursorNo;

  /// Total page count returned by a v5 page datasource.
  final int? totalPages;

  final bool hasNext;
  final bool hasPrevious;

  /// Total number of items when reported by the backend.
  final int? totalCount;

  final DateTime fetchedAt;

  SuperPaginationMeta copyWith({
    int? page,
    int? pageSize,
    String? nextCursor,
    String? previousCursor,
    int? lastCursorNo,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    int? totalCount,
    DateTime? fetchedAt,
  }) {
    return SuperPaginationMeta(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      nextCursor: nextCursor ?? this.nextCursor,
      previousCursor: previousCursor ?? this.previousCursor,
      lastCursorNo: lastCursorNo ?? this.lastCursorNo,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      totalCount: totalCount ?? this.totalCount,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'nextCursor': nextCursor,
      'previousCursor': previousCursor,
      'lastCursorNo': lastCursorNo,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
      'totalCount': totalCount,
      'fetchedAt': fetchedAt.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  factory SuperPaginationMeta.fromJson(Map<String, dynamic> json) {
    return SuperPaginationMeta(
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int? ?? json['limit'] as int?,
      nextCursor: json['nextCursor'] as String? ?? json['next'] as String?,
      previousCursor:
          json['previousCursor'] as String? ?? json['previous'] as String?,
      lastCursorNo:
          json['lastCursorNo'] as int? ?? json['last_cursor_no'] as int?,
      totalPages: json['totalPages'] as int? ?? json['total_pages'] as int?,
      hasNext: json['hasNext'] as bool? ??
          json['has_next'] as bool? ??
          json['nextCursor'] != null,
      hasPrevious: json['hasPrevious'] as bool? ??
          json['has_previous'] as bool? ??
          json['previousCursor'] != null,
      totalCount: json['totalCount'] as int? ??
          json['total_count'] as int? ??
          json['totalItems'] as int? ??
          json['total_items'] as int?,
      fetchedAt: json['fetchedAt'] != null
          ? DateTime.tryParse(json['fetchedAt'] as String)
          : DateTime.now(),
    );
  }
}
