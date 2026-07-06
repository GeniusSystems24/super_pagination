/// Lightweight request descriptor used by the pagination cubit.
///
/// [SuperPaginationRequest] encapsulates all the information needed to fetch
/// a page of data. It supports both offset-based (page/pageSize) and
/// cursor-based pagination strategies.
///
/// ## Subclassing for type-safe custom requests
///
/// Extend [SuperPaginationRequest] to attach strongly-typed fields to every
/// page fetch.  **You must override [copyWith] in the subclass** so that
/// the cubit can create the next-page request while preserving your
/// custom fields:
///
/// ```dart
/// class ProductRequest extends SuperPaginationRequest {
///   const ProductRequest({
///     super.page,
///     super.pageSize,
///     required this.category,
///     this.maxPrice,
///   });
///
///   final String category;
///   final double? maxPrice;
///
///   @override
///   ProductRequest copyWith({
///     int? page,
///     int? pageSize,
///     String? cursor,
///     Map<String, dynamic>? filters,
///     Map<String, dynamic>? extra,
///     String? searchQuery,
///   }) {
///     return ProductRequest(
///       page: page ?? this.page,
///       pageSize: pageSize ?? this.pageSize,
///       category: category,
///       maxPrice: maxPrice,
///     );
///   }
/// }
///
/// // Then use it with the typed cubit/provider:
/// SuperPaginationCubit<Product, ProductRequest>(
///   request: ProductRequest(page: 1, pageSize: 20, category: 'electronics'),
///   provider: SuperPaginationProvider<Product, ProductRequest>.future(
///     (req) => api.fetchProducts(req.category, maxPrice: req.maxPrice),
///   ),
/// );
/// ```
///
/// ## Offset-based pagination:
///
/// ```dart
/// final request = SuperPaginationRequest(page: 1, pageSize: 20);
/// final nextRequest = request.copyWith(page: request.page + 1);
/// ```
///
/// ## Cursor-based pagination:
///
/// ```dart
/// final request = SuperPaginationRequest(pageSize: 20, cursor: 'next_page_token');
/// ```
///
/// ## With filters:
///
/// ```dart
/// final request = SuperPaginationRequest(
///   page: 1,
///   pageSize: 20,
///   filters: {'category': 'electronics', 'minPrice': 100},
/// );
/// ```
class SuperPaginationRequest {
  const SuperPaginationRequest({
    this.page = 1,
    this.pageSize,
    this.cursor,
    this.filters,
    this.extra,
    this.searchQuery,
  }) : assert(page > 0, 'Page must be greater than 0');

  /// Current page (1-based).
  final int page;

  /// Number of items requested per page.
  final int? pageSize;

  /// Optional cursor/token supplied by the backend.
  final String? cursor;

  /// Optional filter payload forwarded to the data provider.
  final Map<String, dynamic>? filters;

  /// Bag for any additional metadata callers want to persist.
  final Map<String, dynamic>? extra;

  /// Optional search query string for search operations.
  final String? searchQuery;

  /// Creates a copy of this request with the given fields replaced.
  ///
  /// **Override this in every subclass** to ensure the cubit can build
  /// the next-page request while preserving your custom fields.
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
