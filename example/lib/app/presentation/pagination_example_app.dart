import 'package:flutter/material.dart';
import 'package:super_pagination_example/app/controllers/app_theme_controller.dart';
import 'package:super_pagination_example/app/routing/app_router.dart';
import 'package:super_pagination_example/app/theme/app_theme.dart';

/// Root view of the SuperPagination example application.
class PaginationExampleApp extends StatefulWidget {
  const PaginationExampleApp({super.key});

  /// Retained for compatibility with the original example API.
  static final GlobalKey<PaginationExampleAppState> appKey =
      GlobalKey<PaginationExampleAppState>();

  static void toggleTheme() {
    appKey.currentState?.toggleTheme();
  }

  static ThemeMode get themeMode =>
      appKey.currentState?.themeMode ?? AppThemeController.instance.themeMode;

  @override
  State<PaginationExampleApp> createState() => PaginationExampleAppState();
}

class PaginationExampleAppState extends State<PaginationExampleApp> {
  final AppThemeController _themeController = AppThemeController.instance;

  ThemeMode get themeMode => _themeController.themeMode;

  @override
  void initState() {
    super.initState();
    _themeController.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  void toggleTheme() => _themeController.toggleTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: PaginationExampleApp.appKey,
      routerConfig: appRouter,
      title: 'SuperPagination Examples',
      debugShowCheckedModeBanner: false,
      themeMode: _themeController.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}
