import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_navigation_sidebar/super_navigation_sidebar.dart';
import 'package:super_pagination_example/app/controllers/app_theme_controller.dart';
import 'package:super_pagination_example/app/routing/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

/// Persistent application chrome hosted by the typed [ShellRouteData].
///
/// The router remains the single source of truth for page navigation, while
/// [NavigationSidebarController] mirrors the active route so the library can
/// render selection, breadcrumbs, recents, search, shortcuts, and responsive
/// expanded/rail/drawer modes.
class ExampleShell extends StatefulWidget {
  const ExampleShell({
    super.key,
    required this.navigator,
    required this.location,
  });

  final Widget navigator;
  final String location;

  @override
  State<ExampleShell> createState() => _ExampleShellState();
}

class _ExampleShellState extends State<ExampleShell> {
  late final NavigationSidebarController<String> _navigation;

  static const Set<String> _sectionRoots = {
    AppRoutes.basic,
    AppRoutes.streams,
    AppRoutes.advanced,
    AppRoutes.errors,
    AppRoutes.firebase,
  };

  @override
  void initState() {
    super.initState();
    _navigation = NavigationSidebarController<String>(
      sections: _buildNavigationSections(),
      active: widget.location,
      expanded: {_moduleIdFor(widget.location)},
    );
    _syncRouterState();
  }

  @override
  void didUpdateWidget(covariant ExampleShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) _syncRouterState();
  }

  @override
  void dispose() {
    _navigation.dispose();
    super.dispose();
  }

  void _syncRouterState() {
    if (_navigation.node(widget.location) != null &&
        _navigation.active != widget.location) {
      _navigation.navigate(widget.location);
    }
    _navigation.canGoBack = !_sectionRoots.contains(widget.location);
  }

  void _openNode(NavNode<String> node) {
    final route = node.value;
    if (route == null || route == widget.location) return;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final showShellAppBar = _sectionRoots.contains(widget.location);

    return NavShortcutBinder<String>(
      controller: _navigation,
      onNavigate: _openNode,
      child: NavigationShell<String>(
        controller: _navigation,
        headerLayout: NavShellHeaderLayout.spanning,
        paneBehavior: NavPaneBehavior.push,
        contentPadding: EdgeInsets.zero,
        appBarBuilder: (context, mode) {
          if (!showShellAppBar) return const SizedBox.shrink();
          return NavigationSidebarAppBar(
            controller: _navigation,
            mode: mode,
            title: mode == NavSidebarMode.drawer
                ? const Text('Super Pagination')
                : null,
            pageTitle: NavBreadcrumb<String>(controller: _navigation),
            globalSearch: mode == NavSidebarMode.drawer
                ? null
                : NavigationSidebarSearchField(
                    controller: _navigation,
                    hint: 'Filter examples and routes',
                  ),
            actions: [
              _ShellAction(
                tooltip: 'Open package on pub.dev',
                icon: Icons.open_in_new_rounded,
                onPressed: _openPackage,
              ),
              _ShellAction(
                tooltip: 'Toggle light and dark theme',
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                onPressed: AppThemeController.instance.toggleTheme,
              ),
            ],
          );
        },
        sidebarBuilder: (context, mode) => NavigationSidebar<String>(
          controller: _navigation,
          mode: mode,
          header: (context, collapsed) =>
              _SidebarBrand(collapsed: collapsed),
          footer: (context, collapsed) =>
              _SidebarFooter(collapsed: collapsed),
          drawerTitle: 'Example navigation',
          showPaneToggle:
              !showShellAppBar && mode != NavSidebarMode.drawer,
          allowSearchDialog: true,
          favoritable: true,
          aggregateBadges: true,
          shortcutMode: NavShortcutMode.onHover,
          searchHint: 'Search all examples',
          quickAccessTitle: 'Favorites',
          onNavigate: _openNode,
          onSearchPick: _openNode,
        ),
        body: widget.navigator,
      ),
    );
  }

  static String _moduleIdFor(String location) {
    if (location.startsWith(AppRoutes.streams)) return 'module-streams';
    if (location.startsWith(AppRoutes.advanced)) return 'module-advanced';
    if (location.startsWith(AppRoutes.errors)) return 'module-errors';
    if (location.startsWith(AppRoutes.firebase)) return 'module-firebase';
    return 'module-basic';
  }

  static List<NavSection<String>> _buildNavigationSections() => [
        NavSection<String>(
          title: 'Example library',
          items: [
            NavNode<String>(
              id: 'module-basic',
              label: 'Basic',
              icon: Icons.layers_outlined,
              badge: const NavBadge('7'),
              children: [
                _routeNode(
                  route: AppRoutes.basic,
                  label: 'Basic overview',
                  icon: Icons.dashboard_outlined,
                  shortcut: ['g', 'b'],
                ),
                _routeNode(
                  route: AppRoutes.basicListView,
                  label: 'Basic ListView',
                  icon: Icons.list_alt_rounded,
                ),
                _routeNode(
                  route: AppRoutes.gridView,
                  label: 'GridView',
                  icon: Icons.grid_view_rounded,
                ),
                _routeNode(
                  route: AppRoutes.columnLayout,
                  label: 'Column layout',
                  icon: Icons.view_agenda_outlined,
                ),
                _routeNode(
                  route: AppRoutes.rowLayout,
                  label: 'Row layout',
                  icon: Icons.view_week_outlined,
                ),
                _routeNode(
                  route: AppRoutes.pullToRefresh,
                  label: 'Pull to refresh',
                  icon: Icons.refresh_rounded,
                ),
                _routeNode(
                  route: AppRoutes.filterSearch,
                  label: 'Filter and search',
                  icon: Icons.filter_list_rounded,
                ),
                _routeNode(
                  route: AppRoutes.retryMechanism,
                  label: 'Retry mechanism',
                  icon: Icons.replay_rounded,
                ),
              ],
            ),
            NavNode<String>(
              id: 'module-streams',
              label: 'Streams',
              icon: Icons.stream_rounded,
              badge: const NavBadge('6', tone: NavBadgeTone.success),
              children: [
                _routeNode(
                  route: AppRoutes.streams,
                  label: 'Streams overview',
                  icon: Icons.dashboard_outlined,
                  shortcut: ['g', 's'],
                ),
                _routeNode(
                  route: AppRoutes.singleStream,
                  label: 'Single stream',
                  icon: Icons.bolt_outlined,
                ),
                _routeNode(
                  route: AppRoutes.multiStream,
                  label: 'Multi stream',
                  icon: Icons.cable_outlined,
                ),
                _routeNode(
                  route: AppRoutes.mergedStreams,
                  label: 'Merged streams',
                  icon: Icons.merge_rounded,
                ),
                _routeNode(
                  route: AppRoutes.streamAccumulation,
                  label: 'Stream accumulation',
                  icon: Icons.layers_rounded,
                ),
                _routeNode(
                  route: AppRoutes.perPageError,
                  label: 'Per-page error',
                  icon: Icons.error_outline_rounded,
                ),
                _routeNode(
                  route: AppRoutes.dynamicEndOfPagination,
                  label: 'Dynamic end',
                  icon: Icons.dynamic_form_outlined,
                ),
              ],
            ),
            NavNode<String>(
              id: 'module-advanced',
              label: 'Advanced',
              icon: Icons.auto_awesome_rounded,
              badge: const NavBadge('18', tone: NavBadgeTone.warning),
              children: [
                _routeNode(
                  route: AppRoutes.advanced,
                  label: 'Advanced overview',
                  icon: Icons.dashboard_outlined,
                  shortcut: ['g', 'a'],
                ),
                _routeNode(
                  route: AppRoutes.chat,
                  label: 'Chat',
                  icon: Icons.chat_bubble_outline_rounded,
                ),
                _routeNode(
                  route: AppRoutes.cursorPagination,
                  label: 'Cursor pagination',
                  icon: Icons.navigate_next_rounded,
                ),
                _routeNode(
                  route: AppRoutes.keepAlive,
                  label: 'Keep alive',
                  icon: Icons.layers_rounded,
                ),
                _routeNode(
                  route: AppRoutes.providerContext,
                  label: 'Provider context',
                  icon: Icons.account_tree_outlined,
                ),
                _routeNode(
                  route: AppRoutes.horizontalScroll,
                  label: 'Horizontal scroll',
                  icon: Icons.swap_horiz_rounded,
                ),
                _routeNode(
                  route: AppRoutes.pageView,
                  label: 'PageView',
                  icon: Icons.auto_stories_outlined,
                ),
                _routeNode(
                  route: AppRoutes.staggeredGrid,
                  label: 'Staggered grid',
                  icon: Icons.dashboard_customize_outlined,
                ),
                _routeNode(
                  route: AppRoutes.customStates,
                  label: 'Custom states',
                  icon: Icons.palette_outlined,
                ),
                _routeNode(
                  route: AppRoutes.scrollControl,
                  label: 'Scroll control',
                  icon: Icons.open_in_full_rounded,
                ),
                _routeNode(
                  route: AppRoutes.beforeBuildHook,
                  label: 'Before-build hook',
                  icon: Icons.code_rounded,
                ),
                _routeNode(
                  route: AppRoutes.hasReachedEnd,
                  label: 'Reached end',
                  icon: Icons.flag_outlined,
                ),
                _routeNode(
                  route: AppRoutes.customViewBuilder,
                  label: 'Custom view builder',
                  icon: Icons.build_outlined,
                ),
                _routeNode(
                  route: AppRoutes.reorderableList,
                  label: 'Reorderable list',
                  icon: Icons.reorder_rounded,
                ),
                _routeNode(
                  route: AppRoutes.stateSeparation,
                  label: 'State separation',
                  icon: Icons.account_tree_outlined,
                ),
                _routeNode(
                  route: AppRoutes.smartPreloading,
                  label: 'Smart preloading',
                  icon: Icons.speed_rounded,
                ),
                _routeNode(
                  route: AppRoutes.dataOperations,
                  label: 'Data operations',
                  icon: Icons.data_object_rounded,
                ),
                _routeNode(
                  route: AppRoutes.dataAge,
                  label: 'Data age',
                  icon: Icons.schedule_outlined,
                ),
                _routeNode(
                  route: AppRoutes.sorting,
                  label: 'Sorting',
                  icon: Icons.sort_rounded,
                ),
              ],
            ),
            NavNode<String>(
              id: 'module-errors',
              label: 'Errors',
              icon: Icons.bug_report_outlined,
              badge: const NavBadge('7', tone: NavBadgeTone.danger),
              children: [
                _routeNode(
                  route: AppRoutes.errors,
                  label: 'Errors overview',
                  icon: Icons.dashboard_outlined,
                  shortcut: ['g', 'e'],
                ),
                _routeNode(
                  route: AppRoutes.basicError,
                  label: 'Basic error',
                  icon: Icons.error_outline_rounded,
                ),
                _routeNode(
                  route: AppRoutes.networkErrors,
                  label: 'Network errors',
                  icon: Icons.wifi_off_rounded,
                ),
                _routeNode(
                  route: AppRoutes.retryPatterns,
                  label: 'Retry patterns',
                  icon: Icons.replay_circle_filled_outlined,
                ),
                _routeNode(
                  route: AppRoutes.customErrorWidgets,
                  label: 'Custom widgets',
                  icon: Icons.widgets_outlined,
                ),
                _routeNode(
                  route: AppRoutes.errorRecovery,
                  label: 'Error recovery',
                  icon: Icons.health_and_safety_outlined,
                ),
                _routeNode(
                  route: AppRoutes.gracefulDegradation,
                  label: 'Graceful degradation',
                  icon: Icons.shield_outlined,
                ),
                _routeNode(
                  route: AppRoutes.loadMoreErrors,
                  label: 'Load-more errors',
                  icon: Icons.more_horiz_rounded,
                ),
              ],
            ),
            NavNode<String>(
              id: 'module-firebase',
              label: 'Firebase',
              icon: Icons.cloud_outlined,
              badge: const NavBadge('7', tone: NavBadgeTone.success),
              children: [
                _routeNode(
                  route: AppRoutes.firebase,
                  label: 'Firebase overview',
                  icon: Icons.dashboard_outlined,
                  shortcut: ['g', 'c'],
                ),
                _routeNode(
                  route: AppRoutes.firestorePagination,
                  label: 'Firestore pagination',
                  icon: Icons.storage_outlined,
                ),
                _routeNode(
                  route: AppRoutes.firestoreRealtime,
                  label: 'Firestore realtime',
                  icon: Icons.sync_rounded,
                ),
                _routeNode(
                  route: AppRoutes.realtimeDatabase,
                  label: 'Realtime database',
                  icon: Icons.bolt_outlined,
                ),
                _routeNode(
                  route: AppRoutes.firestoreFilters,
                  label: 'Firestore filters',
                  icon: Icons.filter_alt_outlined,
                ),
                _routeNode(
                  route: AppRoutes.offlineSupport,
                  label: 'Offline support',
                  icon: Icons.cloud_off_outlined,
                ),
                _routeNode(
                  route: AppRoutes.seedData,
                  label: 'Seed data',
                  icon: Icons.dataset_outlined,
                ),
              ],
            ),
          ],
        ),
      ];

  static NavNode<String> _routeNode({
    required String route,
    required String label,
    required IconData icon,
    List<String>? shortcut,
  }) =>
      NavNode<String>(
        id: route,
        label: label,
        icon: icon,
        value: route,
        shortcut: shortcut,
        code: _routeCode(route),
        keywords: [route.replaceAll('/', ' ')],
      );

  static String _routeCode(String route) {
    final normalized = route
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .map((segment) => segment.substring(0, 1).toUpperCase())
        .join();
    return normalized.isEmpty ? 'HOME' : normalized;
  }

  static void _openPackage() {
    launchUrl(
      Uri.parse('https://pub.dev/packages/super_pagination'),
      mode: LaunchMode.externalApplication,
    );
  }
}

class _SidebarBrand extends StatelessWidget {
  const _SidebarBrand({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final t = NavigationSidebarThemeData.of(context);
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(t.radiusLg),
            ),
            child: Icon(
              Icons.view_stream_rounded,
              size: 19,
              color: cs.onPrimary,
            ),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Super Pagination',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: t.fg1,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Example library',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: t.fg3, fontSize: 11.5),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final t = NavigationSidebarThemeData.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;

    if (collapsed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SidebarIconAction(
            tooltip: 'Open package on pub.dev',
            icon: Icons.open_in_new_rounded,
            onPressed: _ExampleShellState._openPackage,
          ),
          _SidebarIconAction(
            tooltip: 'Toggle theme',
            icon: dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            onPressed: AppThemeController.instance.toggleTheme,
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(height: 1, color: t.border),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _ExampleShellState._openPackage,
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: t.fg2,
            ),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text('Package on pub.dev'),
          ),
          TextButton.icon(
            onPressed: AppThemeController.instance.toggleTheme,
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: t.fg2,
            ),
            icon: Icon(
              dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 18,
            ),
            label: Text(dark ? 'Use light theme' : 'Use dark theme'),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.route_rounded, size: 15, color: t.fg3),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'TypedShellRoute + NavigationShell',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: t.fg3, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarIconAction extends StatelessWidget {
  const _SidebarIconAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = NavigationSidebarThemeData.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      color: t.fg3,
      icon: Icon(icon, size: 19),
    );
  }
}

class _ShellAction extends StatelessWidget {
  const _ShellAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final t = NavigationSidebarThemeData.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      color: t.fg2,
      icon: Icon(icon, size: 20),
    );
  }
}
