part of '../../pagination_feature.dart';

/// A paginated GridView widget with automatic pagination support.
///
/// This widget provides a convenient way to display paginated data in a GridView
/// with built-in support for loading states, error handling, and infinite scrolling.
///
/// Example usage:
/// ```dart
/// SuperPaginationGridView.withProvider(
///   request: SuperPaginationRequest(page: 1, pageSize: 20),
///   provider: SuperPaginationProvider.future((request) => fetchProducts(request)),
///   itemBuilder: (context, items, index) {
///     return ProductCard(product: items[index]);
///   },
///   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
/// )
/// ```
class SuperPaginationGridView<T, R extends SuperPaginationRequest> extends SuperPagination<T, R> {
  /// Creates a SuperPaginationGridView with a provider for data fetching.
  ///
  /// The [request] and [provider] are required to configure pagination.
  /// Use [itemBuilder] to define how each item should be rendered.
  /// The [gridDelegate] controls the layout of items in the grid.
  SuperPaginationGridView.withProvider({
    super.key,
    required super.request,
    required super.provider,
    required super.itemBuilder,
    super.heightOfInitialLoadingAndEmptyWidget,
    super.gridDelegate,
    super.onError,
    super.onReachedEnd,
    super.onLoaded,
    super.emptyWidget,
    super.loadingWidget,
    super.bottomLoader,
    super.shrinkWrap,
    super.reverse,
    super.scrollDirection,
    super.padding,
    super.physics,
    super.scrollController,
    super.allowImplicitScrolling,
    super.keyboardDismissBehavior,
    super.header,
    super.footer,
    super.beforeBuild,
    super.listBuilder,
    super.cacheExtent,
    super.separator,
    super.spacing,
    super.firstPageLoadingBuilder,
    super.firstPageErrorBuilder,
    super.firstPageEmptyBuilder,
    super.loadMoreLoadingBuilder,
    super.loadMoreErrorBuilder,
    super.loadMoreNoMoreItemsBuilder,
    super.invisibleItemsThreshold,
    super.canRefresh,
    super.onRefresh,
    super.itemKeyBuilder,
    super.buildWhen,
    super.insertItemAnimationBuilder,
    super.removeItemAnimationBuilder,
    super.animationDuration,
    super.preserveScrollAnchorOnAppend,
    super.refreshListener,
    super.filterListeners,
    super.onInsertionCallback,
    super.onClear,
    super.logger,
    super.maxPagesInMemory,
    super.retryConfig,
    Duration? dataAge,
  }) : super.gridViewWithProvider();

  /// Creates a SuperPaginationGridView with an external cubit.
  ///
  /// Use this constructor when you want to manage the cubit externally,
  /// such as when using it as a global variable or sharing it across screens.
  SuperPaginationGridView.withCubit({
    super.key,
    required super.cubit,
    required super.itemBuilder,
    super.heightOfInitialLoadingAndEmptyWidget,
    super.gridDelegate,
    super.onError,
    super.onReachedEnd,
    super.onLoaded,
    super.emptyWidget,
    super.loadingWidget,
    super.bottomLoader,
    super.shrinkWrap,
    super.reverse,
    super.scrollDirection,
    super.padding,
    super.physics,
    super.scrollController,
    super.allowImplicitScrolling,
    super.keyboardDismissBehavior,
    super.header,
    super.footer,
    super.beforeBuild,
    super.listBuilder,
    super.cacheExtent,
    super.separator,
    super.spacing,
    super.firstPageLoadingBuilder,
    super.firstPageErrorBuilder,
    super.firstPageEmptyBuilder,
    super.loadMoreLoadingBuilder,
    super.loadMoreErrorBuilder,
    super.loadMoreNoMoreItemsBuilder,
    super.invisibleItemsThreshold,
    super.canRefresh,
    super.onRefresh,
    super.itemKeyBuilder,
    super.buildWhen,
    super.insertItemAnimationBuilder,
    super.removeItemAnimationBuilder,
    super.animationDuration,
    super.preserveScrollAnchorOnAppend,
    super.refreshListener,
    super.filterListeners,
  }) : super.gridViewWithCubit();
}
