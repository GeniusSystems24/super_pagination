import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_core/super_core.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:super_pagination_example/app/controllers/app_theme_controller.dart';
import 'package:super_pagination_example/app/routing/app_router.dart';
import 'package:super_pagination_example/app/routing/app_routes.dart';
import 'package:super_pagination_example/features/home/presentation/controllers/home_controller.dart';
import 'package:super_pagination_example/features/home/presentation/models/example_catalog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();

  final List<ExampleCategory> _categories = [
    ExampleCategory(
      title: 'Basic',
      subtitle: 'Core pagination patterns',
      icon: Icons.layers_outlined,
      items: [
        ExampleItem(
          title: 'Basic ListView',
          description: 'Simple paginated ListView with products',
          icon: Icons.list_alt_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.basicListView,
        ),
        ExampleItem(
          title: 'GridView',
          description: 'Paginated GridView with product cards',
          icon: Icons.grid_view_rounded,
          color: const Color(0xFF1DB88A),
          route: AppRoutes.gridView,
        ),
        ExampleItem(
          title: 'Column Layout',
          description: 'Non-scrollable column inside scroll view',
          icon: Icons.view_agenda_rounded,
          color: const Color(0xFF1DB88A),
          route: AppRoutes.columnLayout,
        ),
        ExampleItem(
          title: 'Row Layout',
          description: 'Non-scrollable row inside scroll view',
          icon: Icons.view_week_rounded,
          color: const Color(0xFFEF4444),
          route: AppRoutes.rowLayout,
        ),
        ExampleItem(
          title: 'Pull to Refresh',
          description: 'Swipe down to refresh content',
          icon: Icons.refresh_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.pullToRefresh,
        ),
        ExampleItem(
          title: 'Filter & Search',
          description: 'Paginated list with filtering',
          icon: Icons.filter_list_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.filterSearch,
        ),
        ExampleItem(
          title: 'Retry Mechanism',
          description: 'Auto-retry with exponential backoff',
          icon: Icons.replay_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.retryMechanism,
        ),
      ],
    ),
    ExampleCategory(
      title: 'Streams',
      subtitle: 'Real-time data updates',
      icon: Icons.stream_rounded,
      items: [
        ExampleItem(
          title: 'Single Stream',
          description: 'Real-time updates from single stream',
          icon: Icons.bolt_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.singleStream,
        ),
        ExampleItem(
          title: 'Multi Stream',
          description: 'Multiple streams with different rates',
          icon: Icons.cable_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.multiStream,
        ),
        ExampleItem(
          title: 'Merged Streams',
          description: 'Merge streams into one unified stream',
          icon: Icons.merge_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.mergedStreams,
        ),
        ExampleItem(
          title: 'Stream Accumulation',
          description: 'Each page keeps its own live subscription',
          icon: Icons.layers_rounded,
          color: const Color(0xFF1DB88A),
          route: AppRoutes.streamAccumulation,
        ),
        ExampleItem(
          title: 'Per-Page Error',
          description: 'state.pageErrors isolates failing streams',
          icon: Icons.error_outline_rounded,
          color: const Color(0xFFEF4444),
          route: AppRoutes.perPageError,
        ),
        ExampleItem(
          title: 'Dynamic End-of-Pagination',
          description: 'End re-evaluated when page count changes',
          icon: Icons.dynamic_form_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.dynamicEndOfPagination,
        ),
      ],
    ),
    ExampleCategory(
      title: 'Advanced',
      subtitle: 'Complex pagination scenarios',
      icon: Icons.auto_awesome_rounded,
      items: [
        ExampleItem(
          title: 'Chat Example',
          description: 'Scroll navigation with chat UI',
          icon: Icons.chat_bubble_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.chat,
        ),
        ExampleItem(
          title: 'Cursor Pagination',
          description: 'Cursor-based pagination for real-time',
          icon: Icons.navigate_next_rounded,
          color: const Color(0xFF1DB88A),
          route: AppRoutes.cursorPagination,
        ),
        ExampleItem(
          title: 'Horizontal Scroll',
          description: 'Horizontal scrolling with pagination',
          icon: Icons.swap_horiz_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.horizontalScroll,
        ),
        ExampleItem(
          title: 'PageView',
          description: 'Swipeable pages with auto pagination',
          icon: Icons.auto_stories_rounded,
          color: const Color(0xFFEF4444),
          route: AppRoutes.pageView,
        ),
        ExampleItem(
          title: 'Staggered Grid',
          description: 'Pinterest-like masonry layout',
          icon: Icons.dashboard_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.staggeredGrid,
        ),
        ExampleItem(
          title: 'Custom States',
          description: 'Custom loading, empty, error states',
          icon: Icons.palette_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.customStates,
        ),
        ExampleItem(
          title: 'Scroll Control',
          description: 'Programmatic scrolling to items',
          icon: Icons.open_in_full_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.scrollControl,
        ),
        ExampleItem(
          title: 'beforeBuild Hook',
          description: 'Execute logic before rendering',
          icon: Icons.code_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.beforeBuildHook,
        ),
        ExampleItem(
          title: 'hasReachedEnd',
          description: 'Detect when pagination ends',
          icon: Icons.check_circle_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.hasReachedEnd,
        ),
        ExampleItem(
          title: 'Custom View Builder',
          description: 'Complete control with custom builder',
          icon: Icons.construction_rounded,
          color: const Color(0xFF1DB88A),
          route: AppRoutes.customViewBuilder,
        ),
        ExampleItem(
          title: 'Reorderable List',
          description: 'Drag and drop to reorder items',
          icon: Icons.drag_indicator_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.reorderableList,
        ),
        ExampleItem(
          title: 'State Separation',
          description: 'Different UI for page states',
          icon: Icons.call_split_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.stateSeparation,
        ),
        ExampleItem(
          title: 'Super Preloading',
          description: 'Load items before reaching end',
          icon: Icons.speed_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.smartPreloading,
        ),
        ExampleItem(
          title: 'Data Operations',
          description: 'Add, remove, update, clear items',
          icon: Icons.data_object_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.dataOperations,
        ),
        ExampleItem(
          title: 'Data Age & Expiration',
          description: 'Auto-refresh after expiration',
          icon: Icons.timer_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.dataAge,
        ),
        ExampleItem(
          title: 'Sorting & Orders',
          description: 'Programmatic sorting with orders',
          icon: Icons.sort_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.sorting,
        ),
      ],
    ),
    ExampleCategory(
      title: 'Search',
      subtitle: 'Super search components',
      icon: Icons.search_rounded,
      items: [
        ExampleItem(
          title: 'Search Dropdown',
          description: 'Search with auto-positioning overlay',
          icon: Icons.search_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.searchDropdown,
        ),
        ExampleItem(
          title: 'Multi-Select Search',
          description: 'Search and select multiple items',
          icon: Icons.checklist_rounded,
          color: const Color(0xFFEF4444),
          route: AppRoutes.multiSelectSearch,
        ),
        ExampleItem(
          title: 'Bottom Sheet Search',
          description: 'Fullscreen bottom sheet mode',
          icon: Icons.vertical_align_bottom_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.bottomSheetSearch,
        ),
        ExampleItem(
          title: 'Form Validation',
          description: 'Search with validators & formatters',
          icon: Icons.fact_check_rounded,
          color: const Color(0xFF1DB88A),
          route: AppRoutes.formValidation,
        ),
        ExampleItem(
          title: 'Keyboard Navigation',
          description: 'Arrow keys, Enter, Escape shortcuts',
          icon: Icons.keyboard_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.keyboardNavigation,
        ),
        ExampleItem(
          title: 'Search Theming',
          description: 'Light, dark & custom themes',
          icon: Icons.palette_rounded,
          color: const Color(0xFFEF4444),
          route: AppRoutes.searchTheming,
        ),
        ExampleItem(
          title: 'Async States',
          description: 'Loading, empty & error states',
          icon: Icons.hourglass_empty_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.asyncStates,
        ),
        ExampleItem(
          title: 'Overlay Animations',
          description: '13 animation types & overlay values',
          icon: Icons.animation_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.overlayAnimations,
        ),
        ExampleItem(
          title: 'Key-Based Selection',
          description: 'Select by key/ID instead of object',
          icon: Icons.key_rounded,
          color: const Color(0xFF1DB88A),
          route: AppRoutes.keyBasedSelection,
        ),
        ExampleItem(
          title: 'Initial Selection',
          description: 'Pre-populate with initial values',
          icon: Icons.playlist_add_check_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.initialSelection,
        ),
        ExampleItem(
          title: 'Realistic Examples',
          description: 'E-commerce, team, country, tags',
          icon: Icons.auto_awesome_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.realisticSearchExamples,
        ),
      ],
    ),
    ExampleCategory(
      title: 'Errors',
      subtitle: 'Error handling patterns',
      icon: Icons.bug_report_rounded,
      items: [
        ExampleItem(
          title: 'Basic Error Handling',
          description: 'Simple error display with retry',
          icon: Icons.error_outline_rounded,
          color: const Color(0xFFEF4444),
          route: AppRoutes.basicError,
        ),
        ExampleItem(
          title: 'Network Errors',
          description: 'Timeout, 404, 500 error types',
          icon: Icons.wifi_off_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.networkErrors,
        ),
        ExampleItem(
          title: 'Retry Patterns',
          description: 'Auto, exponential, limited retries',
          icon: Icons.autorenew_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.retryPatterns,
        ),
        ExampleItem(
          title: 'Custom Error Widgets',
          description: 'Pre-built error widget styles',
          icon: Icons.widgets_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.customErrorWidgets,
        ),
        ExampleItem(
          title: 'Error Recovery',
          description: 'Cached data, fallback strategies',
          icon: Icons.healing_rounded,
          color: const Color(0xFF1DB88A),
          route: AppRoutes.errorRecovery,
        ),
        ExampleItem(
          title: 'Graceful Degradation',
          description: 'Offline mode, placeholders',
          icon: Icons.layers_clear_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.gracefulDegradation,
        ),
        ExampleItem(
          title: 'Load More Errors',
          description: 'Handle errors loading more pages',
          icon: Icons.expand_more_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.loadMoreErrors,
        ),
      ],
    ),
    ExampleCategory(
      title: 'Firebase',
      subtitle: 'Firebase integration examples',
      icon: Icons.cloud_rounded,
      items: [
        ExampleItem(
          title: 'Firestore Pagination',
          description: 'Cursor-based Firestore queries',
          icon: Icons.storage_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.firestorePagination,
        ),
        ExampleItem(
          title: 'Firestore Real-time',
          description: 'Live data with snapshots',
          icon: Icons.sync_rounded,
          color: const Color(0xFF1DB88A),
          route: AppRoutes.firestoreRealtime,
        ),
        ExampleItem(
          title: 'Firestore Search',
          description: 'Search with array-contains',
          icon: Icons.manage_search_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.firestoreSearch,
        ),
        ExampleItem(
          title: 'Realtime Database',
          description: 'Firebase RTDB pagination',
          icon: Icons.data_object_rounded,
          color: const Color(0xFFF97316),
          route: AppRoutes.realtimeDatabase,
        ),
        ExampleItem(
          title: 'Firestore Filters',
          description: 'Advanced composite queries',
          icon: Icons.filter_alt_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.firestoreFilters,
        ),
        ExampleItem(
          title: 'Offline Support',
          description: 'Cache & offline persistence',
          icon: Icons.cloud_off_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.offlineSupport,
        ),
        ExampleItem(
          title: 'Seed Data Manager',
          description: 'Populate Firebase with demo data',
          icon: Icons.dataset_rounded,
          color: const Color(0xFF4A7CFF),
          route: AppRoutes.seedData,
        ),
      ],
    ),
  ];

  int get _selectedIndex {
    if (widget.initialIndex < 0) return 0;
    if (widget.initialIndex >= _categories.length) return _categories.length - 1;
    return widget.initialIndex;
  }

  ExampleCategory get _activeCategory => _categories[_selectedIndex];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final category = _activeCategory;
    final items = _controller.filterItems(category);
    final allExamples = _categories.fold<int>(
      0,
      (total, entry) => total + entry.items.length,
    );

    return Scaffold(
      backgroundColor: t.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _PageFrame(
              child: Padding(
                padding: EdgeInsets.only(
                  top: t.spacing.lg,
                  bottom: t.spacing.section,
                ),
                child: _HeroPanel(
                  category: category,
                  categoryCount: category.items.length,
                  allExamples: allExamples,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _PageFrame(
              child: _CategorySwitcher(
                categories: _categories,
                selectedIndex: _selectedIndex,
                onSelected: _navigateToCategory,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _PageFrame(
              child: Padding(
                padding: EdgeInsets.only(top: t.spacing.lg),
                child: _DashboardStats(
                  allExamples: allExamples,
                  categoryExamples: category.items.length,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _PageFrame(
              child: Padding(
                padding: EdgeInsets.only(
                  top: t.spacing.xl,
                  bottom: t.spacing.lg,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SuperSectionHeader(
                        title: category.title,
                        subtitle: category.subtitle,
                        marker: _markerFor(_selectedIndex),
                        trailing: StatusPill(
                          '${items.length} demos',
                          tone: PillTone.accent,
                        ),
                      ),
                    ),
                    if (!t.mode.isMobile) ...[
                      SizedBox(width: t.spacing.lg),
                      SizedBox(
                        width: 320,
                        child: _SearchField(controller: _controller),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (t.mode.isMobile)
            SliverToBoxAdapter(
              child: _PageFrame(
                child: Padding(
                  padding: EdgeInsets.only(bottom: t.spacing.lg),
                  child: _SearchField(controller: _controller),
                ),
              ),
            ),
          if (items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(onClear: _controller.clearSearch),
            )
          else
            SliverToBoxAdapter(
              child: _PageFrame(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: t.spacing.pagePadding.bottom + t.spacing.xl,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 1050
                          ? 3
                          : constraints.maxWidth >= 680
                              ? 2
                              : 1;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: t.spacing.lg,
                          mainAxisSpacing: t.spacing.lg,
                          mainAxisExtent: _ExampleCard.extent,
                        ),
                        itemBuilder: (context, index) =>
                            _ExampleCard(item: items[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToCategory(int index) {
    switch (index) {
      case 0:
        const BasicRoute().go(context);
        return;
      case 1:
        const StreamRoute().go(context);
        return;
      case 2:
        const AdvancedRoute().go(context);
        return;
      case 3:
        const SearchRoute().go(context);
        return;
      case 4:
        const ErrorRoute().go(context);
        return;
      case 5:
        const FirebaseRoute().go(context);
        return;
    }
  }

  static SuperMarker _markerFor(int index) => switch (index % 3) {
        1 => SuperMarker.ledger,
        2 => SuperMarker.notes,
        _ => SuperMarker.identity,
      };
}

class _PageFrame extends StatelessWidget {
  const _PageFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spacing.pagePadding.left),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: child,
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.category,
    required this.categoryCount,
    required this.allExamples,
  });

  final ExampleCategory category;
  final int categoryCount;
  final int allExamples;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final cs = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.spacing.radiusCard),
        border: Border.all(color: t.border),
        boxShadow: t.cardShadow,
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -80,
            top: -130,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withValues(alpha: 0.10),
              ),
            ),
          ),
          PositionedDirectional(
            end: 120,
            bottom: -110,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.tokens.success.withValues(alpha: 0.07),
              ),
            ),
          ),
          Padding(
            padding: t.mode.isMobile
                ? const EdgeInsets.all(20)
                : const EdgeInsets.all(32),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stack = constraints.maxWidth < 760;
                final introduction = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: t.tokens.markerWidth,
                          height: t.tokens.markerHeight,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(
                              t.spacing.radiusPill,
                            ),
                          ),
                        ),
                        SizedBox(width: t.spacing.md),
                        StatusPill(
                          'GeniusLink design system',
                          tone: PillTone.accent,
                        ),
                      ],
                    ),
                    SizedBox(height: t.spacing.lg),
                    Text(
                      'Explore pagination\nwithout the boilerplate.',
                      style: context.superTextTheme.h1.copyWith(
                        color: t.fg1,
                        fontSize: t.mode.isMobile ? 30 : 40,
                        height: 1.08,
                      ),
                    ),
                    SizedBox(height: t.spacing.md),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Text(
                        'A focused gallery of production-ready pagination, streaming, search, error recovery, and Firebase patterns.',
                        style: context.superTextTheme.body.copyWith(
                          color: t.fg3,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: t.spacing.lg),
                    Wrap(
                      spacing: t.spacing.sm,
                      runSpacing: t.spacing.sm,
                      children: [
                        FilledButton.icon(
                          onPressed: () => launchUrl(
                            Uri.parse(
                              'https://pub.dev/packages/super_pagination',
                            ),
                            mode: LaunchMode.externalApplication,
                          ),
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: const Text('View package'),
                        ),
                        OutlinedButton.icon(
                          onPressed: AppThemeController.instance.toggleTheme,
                          icon: Icon(
                            Theme.of(context).brightness == Brightness.dark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            size: 18,
                          ),
                          label: const Text('Toggle theme'),
                        ),
                      ],
                    ),
                  ],
                );
                final snapshot = _CategorySnapshot(
                  category: category,
                  categoryCount: categoryCount,
                  allExamples: allExamples,
                );
                if (stack) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      introduction,
                      SizedBox(height: t.spacing.xl),
                      snapshot,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(flex: 3, child: introduction),
                    SizedBox(width: t.spacing.xl),
                    Expanded(flex: 2, child: snapshot),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySnapshot extends StatelessWidget {
  const _CategorySnapshot({
    required this.category,
    required this.categoryCount,
    required this.allExamples,
  });

  final ExampleCategory category;
  final int categoryCount;
  final int allExamples;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: t.spacing.cardPadding,
      decoration: BoxDecoration(
        color: t.bg.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(t.spacing.radiusCard),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: t.selectionFill(0.12),
              borderRadius: BorderRadius.circular(t.spacing.radiusMd),
            ),
            child: Icon(category.icon, color: cs.primary),
          ),
          SizedBox(height: t.spacing.lg),
          Text(category.title, style: context.superTextTheme.heading.copyWith(color: t.fg1)),
          SizedBox(height: t.spacing.xs),
          Text(category.subtitle, style: context.superTextTheme.body.copyWith(color: t.fg3)),
          SizedBox(height: t.spacing.lg),
          Hairline(color: t.border),
          SizedBox(height: t.spacing.md),
          Row(
            children: [
              Expanded(
                child: _SnapshotValue(label: 'IN SECTION', value: '$categoryCount'),
              ),
              Expanded(
                child: _SnapshotValue(label: 'TOTAL DEMOS', value: '$allExamples'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SnapshotValue extends StatelessWidget {
  const _SnapshotValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.superTextTheme.label.copyWith(color: t.fg4)),
        SizedBox(height: t.spacing.xs),
        Text(value, style: context.superTextTheme.mono.copyWith(color: t.fg1, fontSize: 22)),
      ],
    );
  }
}

class _CategorySwitcher extends StatelessWidget {
  const _CategorySwitcher({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<ExampleCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: t.spacing.sm),
        itemBuilder: (context, index) {
          final category = categories[index];
          return ChoiceChip(
            selected: selectedIndex == index,
            onSelected: (_) => onSelected(index),
            avatar: Icon(category.icon, size: 17),
            label: Text(category.title),
          );
        },
      ),
    );
  }
}

class _DashboardStats extends StatelessWidget {
  const _DashboardStats({
    required this.allExamples,
    required this.categoryExamples,
  });

  final int allExamples;
  final int categoryExamples;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final stats = [
      _StatData('All examples', '$allExamples', Icons.dashboard_outlined),
      _StatData('Current section', '$categoryExamples', Icons.view_module_outlined),
      const _StatData('Responsive modes', '3', Icons.devices_rounded),
      const _StatData('Routing', 'Typed', Icons.route_rounded),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 520
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: t.spacing.md,
            mainAxisSpacing: t.spacing.md,
            mainAxisExtent: 92,
          ),
          itemBuilder: (context, index) => _StatCard(data: stats[index]),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    final cs = Theme.of(context).colorScheme;
    return SuperSectionCard(
      child: Padding(
        padding: EdgeInsets.all(t.spacing.md),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: t.selectionFill(0.08),
                borderRadius: BorderRadius.circular(t.spacing.radiusMd),
              ),
              child: Icon(data.icon, color: cs.primary, size: 20),
            ),
            SizedBox(width: t.spacing.md),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.value, style: context.superTextTheme.heading.copyWith(color: t.fg1)),
                  SizedBox(height: t.spacing.xs),
                  Text(data.label, style: context.superTextTheme.caption.copyWith(color: t.fg3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.searchController,
      decoration: InputDecoration(
        hintText: 'Search this section…',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.searchQuery.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: controller.clearSearch,
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.item});

  /// Fixed grid extent with enough room for desktop spacing and three
  /// description lines. The card content itself deliberately contains no
  /// vertical flex because [SuperCard] shrink-wraps its child column.
  static const double extent = 252;

  final ExampleItem item;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return SuperSectionCard(
      onTap: () => context.go(item.route),
      child: Padding(
        padding: EdgeInsets.all(t.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: t.tintFill(item.color, 0.14),
                    borderRadius: BorderRadius.circular(t.spacing.radiusMd),
                  ),
                  child: Icon(item.icon, color: item.color, size: 21),
                ),
                const Spacer(),
                const StatusPill('Demo', tone: PillTone.neutral),
              ],
            ),
            SizedBox(height: t.spacing.lg),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.superTextTheme.heading.copyWith(color: t.fg1),
            ),
            SizedBox(height: t.spacing.sm),
            SizedBox(
              height: 64,
              child: Text(
                item.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.superTextTheme.body.copyWith(color: t.fg3),
              ),
            ),
            SizedBox(height: t.spacing.md),
            Row(
              children: [
                Text(
                  'OPEN EXAMPLE',
                  style: context.superTextTheme.label.copyWith(color: item.color),
                ),
                SizedBox(width: t.spacing.sm),
                Icon(Icons.arrow_forward_rounded, size: 17, color: item.color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final t = SuperThemeData.of(context);
    return Center(
      child: Padding(
        padding: t.spacing.pagePadding,
        child: SuperSectionCard(
          child: Padding(
            padding: EdgeInsets.all(t.spacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded, size: 42, color: t.fg4),
                SizedBox(height: t.spacing.md),
                Text('No matching examples', style: context.superTextTheme.heading.copyWith(color: t.fg1)),
                SizedBox(height: t.spacing.xs),
                Text('Clear the query and explore the complete section.', style: context.superTextTheme.body.copyWith(color: t.fg3)),
                SizedBox(height: t.spacing.lg),
                OutlinedButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Clear search'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _StatData {
  const _StatData(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}
