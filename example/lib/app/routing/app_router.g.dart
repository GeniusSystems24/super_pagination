// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeShellRouteData,
    ];

RouteBase get $homeShellRouteData => ShellRouteData.$route(
      navigatorKey: HomeShellRouteData.$navigatorKey,
      factory: $HomeShellRouteDataExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/basic',
          factory: $BasicRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'list-view',
              parentNavigatorKey: BasicListViewRoute.$parentNavigatorKey,
              factory: $BasicListViewRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'grid-view',
              parentNavigatorKey: GridViewRoute.$parentNavigatorKey,
              factory: $GridViewRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'column',
              parentNavigatorKey: ColumnLayoutRoute.$parentNavigatorKey,
              factory: $ColumnLayoutRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'row',
              parentNavigatorKey: RowLayoutRoute.$parentNavigatorKey,
              factory: $RowLayoutRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'pull-to-refresh',
              parentNavigatorKey: PullToRefreshRoute.$parentNavigatorKey,
              factory: $PullToRefreshRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'filter-search',
              parentNavigatorKey: FilterSearchRoute.$parentNavigatorKey,
              factory: $FilterSearchRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'retry',
              parentNavigatorKey: RetryMechanismRoute.$parentNavigatorKey,
              factory: $RetryMechanismRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/streams',
          factory: $StreamRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'single',
              parentNavigatorKey: SingleStreamRoute.$parentNavigatorKey,
              factory: $SingleStreamRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'multi',
              parentNavigatorKey: MultiStreamRoute.$parentNavigatorKey,
              factory: $MultiStreamRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'merged',
              parentNavigatorKey: MergedStreamsRoute.$parentNavigatorKey,
              factory: $MergedStreamsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'stream-accumulation',
              parentNavigatorKey: StreamAccumulationRoute.$parentNavigatorKey,
              factory: $StreamAccumulationRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'per-page-error',
              parentNavigatorKey: PerPageErrorRoute.$parentNavigatorKey,
              factory: $PerPageErrorRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'dynamic-end',
              parentNavigatorKey:
                  DynamicEndOfPaginationRoute.$parentNavigatorKey,
              factory: $DynamicEndOfPaginationRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/advanced',
          factory: $AdvancedRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'cursor',
              parentNavigatorKey: CursorPaginationRoute.$parentNavigatorKey,
              factory: $CursorPaginationRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'keep-alive',
              parentNavigatorKey: KeepAliveRoute.$parentNavigatorKey,
              factory: $KeepAliveRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'provider-context',
              parentNavigatorKey: ProviderContextRoute.$parentNavigatorKey,
              factory: $ProviderContextRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'horizontal',
              parentNavigatorKey: HorizontalScrollRoute.$parentNavigatorKey,
              factory: $HorizontalScrollRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'page-view',
              parentNavigatorKey: PageViewRoute.$parentNavigatorKey,
              factory: $PageViewRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'staggered-grid',
              parentNavigatorKey: StaggeredGridRoute.$parentNavigatorKey,
              factory: $StaggeredGridRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'custom-states',
              parentNavigatorKey: CustomStatesRoute.$parentNavigatorKey,
              factory: $CustomStatesRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'scroll-control',
              parentNavigatorKey: ScrollControlRoute.$parentNavigatorKey,
              factory: $ScrollControlRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'before-build',
              parentNavigatorKey: BeforeBuildHookRoute.$parentNavigatorKey,
              factory: $BeforeBuildHookRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'reached-end',
              parentNavigatorKey: HasReachedEndRoute.$parentNavigatorKey,
              factory: $HasReachedEndRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'custom-builder',
              parentNavigatorKey: CustomViewBuilderRoute.$parentNavigatorKey,
              factory: $CustomViewBuilderRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'reorderable',
              parentNavigatorKey: ReorderableListRoute.$parentNavigatorKey,
              factory: $ReorderableListRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'state-separation',
              parentNavigatorKey: StateSeparationRoute.$parentNavigatorKey,
              factory: $StateSeparationRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'preloading',
              parentNavigatorKey: SuperPreloadingRoute.$parentNavigatorKey,
              factory: $SuperPreloadingRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'data-operations',
              parentNavigatorKey: DataOperationsRoute.$parentNavigatorKey,
              factory: $DataOperationsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'data-age',
              parentNavigatorKey: DataAgeRoute.$parentNavigatorKey,
              factory: $DataAgeRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'sorting',
              parentNavigatorKey: SortingRoute.$parentNavigatorKey,
              factory: $SortingRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'chat',
              parentNavigatorKey: ChatRoute.$parentNavigatorKey,
              factory: $ChatRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/errors',
          factory: $ErrorRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'basic',
              parentNavigatorKey: BasicErrorRoute.$parentNavigatorKey,
              factory: $BasicErrorRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'network',
              parentNavigatorKey: NetworkErrorsRoute.$parentNavigatorKey,
              factory: $NetworkErrorsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'retry-patterns',
              parentNavigatorKey: RetryPatternsRoute.$parentNavigatorKey,
              factory: $RetryPatternsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'custom-widgets',
              parentNavigatorKey: CustomErrorWidgetsRoute.$parentNavigatorKey,
              factory: $CustomErrorWidgetsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'recovery',
              parentNavigatorKey: ErrorRecoveryRoute.$parentNavigatorKey,
              factory: $ErrorRecoveryRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'graceful',
              parentNavigatorKey: GracefulDegradationRoute.$parentNavigatorKey,
              factory: $GracefulDegradationRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'load-more',
              parentNavigatorKey: LoadMoreErrorsRoute.$parentNavigatorKey,
              factory: $LoadMoreErrorsRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/firebase',
          factory: $FirebaseRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'firestore-pagination',
              parentNavigatorKey: FirestorePaginationRoute.$parentNavigatorKey,
              factory: $FirestorePaginationRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'firestore-realtime',
              parentNavigatorKey: FirestoreRealtimeRoute.$parentNavigatorKey,
              factory: $FirestoreRealtimeRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'realtime-database',
              parentNavigatorKey: RealtimeDatabaseRoute.$parentNavigatorKey,
              factory: $RealtimeDatabaseRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'firestore-filters',
              parentNavigatorKey: FirestoreFiltersRoute.$parentNavigatorKey,
              factory: $FirestoreFiltersRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'offline-support',
              parentNavigatorKey: OfflineSupportRoute.$parentNavigatorKey,
              factory: $OfflineSupportRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'seed-data',
              parentNavigatorKey: SeedDataRoute.$parentNavigatorKey,
              factory: $SeedDataRoute._fromState,
            ),
          ],
        ),
      ],
    );

extension $HomeShellRouteDataExtension on HomeShellRouteData {
  static HomeShellRouteData _fromState(GoRouterState state) =>
      const HomeShellRouteData();
}

mixin $BasicRoute on GoRouteData {
  static BasicRoute _fromState(GoRouterState state) => const BasicRoute();

  @override
  String get location => GoRouteData.$location(
        '/basic',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BasicListViewRoute on GoRouteData {
  static BasicListViewRoute _fromState(GoRouterState state) =>
      const BasicListViewRoute();

  @override
  String get location => GoRouteData.$location(
        '/basic/list-view',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GridViewRoute on GoRouteData {
  static GridViewRoute _fromState(GoRouterState state) => const GridViewRoute();

  @override
  String get location => GoRouteData.$location(
        '/basic/grid-view',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ColumnLayoutRoute on GoRouteData {
  static ColumnLayoutRoute _fromState(GoRouterState state) =>
      const ColumnLayoutRoute();

  @override
  String get location => GoRouteData.$location(
        '/basic/column',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RowLayoutRoute on GoRouteData {
  static RowLayoutRoute _fromState(GoRouterState state) =>
      const RowLayoutRoute();

  @override
  String get location => GoRouteData.$location(
        '/basic/row',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PullToRefreshRoute on GoRouteData {
  static PullToRefreshRoute _fromState(GoRouterState state) =>
      const PullToRefreshRoute();

  @override
  String get location => GoRouteData.$location(
        '/basic/pull-to-refresh',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FilterSearchRoute on GoRouteData {
  static FilterSearchRoute _fromState(GoRouterState state) =>
      const FilterSearchRoute();

  @override
  String get location => GoRouteData.$location(
        '/basic/filter-search',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RetryMechanismRoute on GoRouteData {
  static RetryMechanismRoute _fromState(GoRouterState state) =>
      const RetryMechanismRoute();

  @override
  String get location => GoRouteData.$location(
        '/basic/retry',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StreamRoute on GoRouteData {
  static StreamRoute _fromState(GoRouterState state) => const StreamRoute();

  @override
  String get location => GoRouteData.$location(
        '/streams',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SingleStreamRoute on GoRouteData {
  static SingleStreamRoute _fromState(GoRouterState state) =>
      const SingleStreamRoute();

  @override
  String get location => GoRouteData.$location(
        '/streams/single',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MultiStreamRoute on GoRouteData {
  static MultiStreamRoute _fromState(GoRouterState state) =>
      const MultiStreamRoute();

  @override
  String get location => GoRouteData.$location(
        '/streams/multi',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MergedStreamsRoute on GoRouteData {
  static MergedStreamsRoute _fromState(GoRouterState state) =>
      const MergedStreamsRoute();

  @override
  String get location => GoRouteData.$location(
        '/streams/merged',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StreamAccumulationRoute on GoRouteData {
  static StreamAccumulationRoute _fromState(GoRouterState state) =>
      const StreamAccumulationRoute();

  @override
  String get location => GoRouteData.$location(
        '/streams/stream-accumulation',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PerPageErrorRoute on GoRouteData {
  static PerPageErrorRoute _fromState(GoRouterState state) =>
      const PerPageErrorRoute();

  @override
  String get location => GoRouteData.$location(
        '/streams/per-page-error',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DynamicEndOfPaginationRoute on GoRouteData {
  static DynamicEndOfPaginationRoute _fromState(GoRouterState state) =>
      const DynamicEndOfPaginationRoute();

  @override
  String get location => GoRouteData.$location(
        '/streams/dynamic-end',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AdvancedRoute on GoRouteData {
  static AdvancedRoute _fromState(GoRouterState state) => const AdvancedRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CursorPaginationRoute on GoRouteData {
  static CursorPaginationRoute _fromState(GoRouterState state) =>
      const CursorPaginationRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/cursor',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}


mixin $KeepAliveRoute on GoRouteData {
  static KeepAliveRoute _fromState(GoRouterState state) =>
      const KeepAliveRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/keep-alive',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProviderContextRoute on GoRouteData {
  static ProviderContextRoute _fromState(GoRouterState state) =>
      const ProviderContextRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/provider-context',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HorizontalScrollRoute on GoRouteData {
  static HorizontalScrollRoute _fromState(GoRouterState state) =>
      const HorizontalScrollRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/horizontal',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PageViewRoute on GoRouteData {
  static PageViewRoute _fromState(GoRouterState state) => const PageViewRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/page-view',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StaggeredGridRoute on GoRouteData {
  static StaggeredGridRoute _fromState(GoRouterState state) =>
      const StaggeredGridRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/staggered-grid',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CustomStatesRoute on GoRouteData {
  static CustomStatesRoute _fromState(GoRouterState state) =>
      const CustomStatesRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/custom-states',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScrollControlRoute on GoRouteData {
  static ScrollControlRoute _fromState(GoRouterState state) =>
      const ScrollControlRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/scroll-control',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BeforeBuildHookRoute on GoRouteData {
  static BeforeBuildHookRoute _fromState(GoRouterState state) =>
      const BeforeBuildHookRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/before-build',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HasReachedEndRoute on GoRouteData {
  static HasReachedEndRoute _fromState(GoRouterState state) =>
      const HasReachedEndRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/reached-end',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CustomViewBuilderRoute on GoRouteData {
  static CustomViewBuilderRoute _fromState(GoRouterState state) =>
      const CustomViewBuilderRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/custom-builder',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ReorderableListRoute on GoRouteData {
  static ReorderableListRoute _fromState(GoRouterState state) =>
      const ReorderableListRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/reorderable',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StateSeparationRoute on GoRouteData {
  static StateSeparationRoute _fromState(GoRouterState state) =>
      const StateSeparationRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/state-separation',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SuperPreloadingRoute on GoRouteData {
  static SuperPreloadingRoute _fromState(GoRouterState state) =>
      const SuperPreloadingRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/preloading',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DataOperationsRoute on GoRouteData {
  static DataOperationsRoute _fromState(GoRouterState state) =>
      const DataOperationsRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/data-operations',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DataAgeRoute on GoRouteData {
  static DataAgeRoute _fromState(GoRouterState state) => const DataAgeRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/data-age',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SortingRoute on GoRouteData {
  static SortingRoute _fromState(GoRouterState state) => const SortingRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/sorting',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChatRoute on GoRouteData {
  static ChatRoute _fromState(GoRouterState state) => const ChatRoute();

  @override
  String get location => GoRouteData.$location(
        '/advanced/chat',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ErrorRoute on GoRouteData {
  static ErrorRoute _fromState(GoRouterState state) => const ErrorRoute();

  @override
  String get location => GoRouteData.$location(
        '/errors',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BasicErrorRoute on GoRouteData {
  static BasicErrorRoute _fromState(GoRouterState state) =>
      const BasicErrorRoute();

  @override
  String get location => GoRouteData.$location(
        '/errors/basic',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NetworkErrorsRoute on GoRouteData {
  static NetworkErrorsRoute _fromState(GoRouterState state) =>
      const NetworkErrorsRoute();

  @override
  String get location => GoRouteData.$location(
        '/errors/network',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RetryPatternsRoute on GoRouteData {
  static RetryPatternsRoute _fromState(GoRouterState state) =>
      const RetryPatternsRoute();

  @override
  String get location => GoRouteData.$location(
        '/errors/retry-patterns',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CustomErrorWidgetsRoute on GoRouteData {
  static CustomErrorWidgetsRoute _fromState(GoRouterState state) =>
      const CustomErrorWidgetsRoute();

  @override
  String get location => GoRouteData.$location(
        '/errors/custom-widgets',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ErrorRecoveryRoute on GoRouteData {
  static ErrorRecoveryRoute _fromState(GoRouterState state) =>
      const ErrorRecoveryRoute();

  @override
  String get location => GoRouteData.$location(
        '/errors/recovery',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GracefulDegradationRoute on GoRouteData {
  static GracefulDegradationRoute _fromState(GoRouterState state) =>
      const GracefulDegradationRoute();

  @override
  String get location => GoRouteData.$location(
        '/errors/graceful',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LoadMoreErrorsRoute on GoRouteData {
  static LoadMoreErrorsRoute _fromState(GoRouterState state) =>
      const LoadMoreErrorsRoute();

  @override
  String get location => GoRouteData.$location(
        '/errors/load-more',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FirebaseRoute on GoRouteData {
  static FirebaseRoute _fromState(GoRouterState state) => const FirebaseRoute();

  @override
  String get location => GoRouteData.$location(
        '/firebase',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FirestorePaginationRoute on GoRouteData {
  static FirestorePaginationRoute _fromState(GoRouterState state) =>
      const FirestorePaginationRoute();

  @override
  String get location => GoRouteData.$location(
        '/firebase/firestore-pagination',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FirestoreRealtimeRoute on GoRouteData {
  static FirestoreRealtimeRoute _fromState(GoRouterState state) =>
      const FirestoreRealtimeRoute();

  @override
  String get location => GoRouteData.$location(
        '/firebase/firestore-realtime',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RealtimeDatabaseRoute on GoRouteData {
  static RealtimeDatabaseRoute _fromState(GoRouterState state) =>
      const RealtimeDatabaseRoute();

  @override
  String get location => GoRouteData.$location(
        '/firebase/realtime-database',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FirestoreFiltersRoute on GoRouteData {
  static FirestoreFiltersRoute _fromState(GoRouterState state) =>
      const FirestoreFiltersRoute();

  @override
  String get location => GoRouteData.$location(
        '/firebase/firestore-filters',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OfflineSupportRoute on GoRouteData {
  static OfflineSupportRoute _fromState(GoRouterState state) =>
      const OfflineSupportRoute();

  @override
  String get location => GoRouteData.$location(
        '/firebase/offline-support',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SeedDataRoute on GoRouteData {
  static SeedDataRoute _fromState(GoRouterState state) => const SeedDataRoute();

  @override
  String get location => GoRouteData.$location(
        '/firebase/seed-data',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
