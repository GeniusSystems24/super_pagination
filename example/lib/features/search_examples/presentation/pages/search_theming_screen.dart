import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
import 'package:super_pagination/super_pagination.dart';

import 'package:super_pagination_example/app/dependencies/example_dependencies.dart';
import 'package:super_pagination_example/shared/domain/entities/product.dart';

/// Demonstrates how SuperSearchTheme follows the same palette, brightness, and
/// responsive tokens as the rest of the GeniusLink design system.
class SearchThemingScreen extends StatefulWidget {
  const SearchThemingScreen({super.key});

  @override
  State<SearchThemingScreen> createState() => _SearchThemingScreenState();
}

class _SearchThemingScreenState extends State<SearchThemingScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final mode = SuperDeviceMode.forWidth(MediaQuery.sizeOf(context).width);

    return Theme(
      data: _themeFor(
        context,
        palette: SuperPalette.bluePalette,
        mode: mode,
      ),
      child: Builder(
        builder: (context) {
          final superTheme = SuperThemeData.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Search Theming'),
              actions: [
                PopupMenuButton<ThemeMode>(
                  icon: Icon(_themeIcon),
                  onSelected: (value) => setState(() => _themeMode = value),
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: ThemeMode.system,
                      child: _ThemeModeItem(
                        icon: Icons.brightness_auto,
                        label: 'System',
                      ),
                    ),
                    PopupMenuItem(
                      value: ThemeMode.light,
                      child: _ThemeModeItem(
                        icon: Icons.light_mode,
                        label: 'Light',
                      ),
                    ),
                    PopupMenuItem(
                      value: ThemeMode.dark,
                      child: _ThemeModeItem(
                        icon: Icons.dark_mode,
                        label: 'Dark',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: superTheme.sizing.contentColumn,
                ),
                child: ListView(
                  padding: superTheme.spacing.pagePadding,
                  children: [
                    SuperSectionCard(
                      header: SuperSectionHeader(
                        title: 'Shared theme source',
                        subtitle:
                            'Search surfaces are generated from SuperMaterialThemeData and SuperPalette.',
                        trailing: StatusPill(
                          _themeMode.name,
                          tone: PillTone.accent,
                        ),
                      ),
                    ),
                    SizedBox(height: superTheme.spacing.section),
                    _PaletteSearchSection(
                      title: 'GeniusLink Blue',
                      subtitle: 'Default package theme and automatic fallback.',
                      marker: SuperMarker.identity,
                      palette: SuperPalette.bluePalette,
                      theme: _themeFor(
                        context,
                        palette: SuperPalette.bluePalette,
                        mode: mode,
                      ),
                      child: _buildDropdown(),
                    ),
                    SizedBox(height: superTheme.spacing.section),
                    _PaletteSearchSection(
                      title: 'Purple Palette',
                      subtitle:
                          'A complete palette swap without manually copying search colors.',
                      marker: SuperMarker.notes,
                      palette: SuperPalette.purplePalette,
                      theme: _themeFor(
                        context,
                        palette: SuperPalette.purplePalette,
                        mode: mode,
                      ),
                      child: _buildDropdown(),
                    ),
                    SizedBox(height: superTheme.spacing.section),
                    _PaletteSearchSection(
                      title: 'Success Green',
                      subtitle:
                          'Search fields, overlay, focus, selection, and loaders stay synchronized.',
                      marker: SuperMarker.ledger,
                      palette: SuperPalette.greenPalette,
                      theme: _themeFor(
                        context,
                        palette: SuperPalette.greenPalette,
                        mode: mode,
                      ),
                      child: _buildDropdown(),
                    ),
                    SizedBox(height: superTheme.spacing.section),
                    const SuperSectionCard(
                      header: SuperSectionHeader(
                        title: 'Override surface',
                        subtitle:
                            'All existing SuperSearchTheme properties remain available for focused overrides.',
                      ),
                      child: _PropertyGroups(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown() {
    return SuperSearchDropdown<Product, Product>.withProvider(
      request: const SuperPaginationRequest(page: 1, pageSize: 10),
      provider: SuperPaginationProvider.future(
        (request) => ExampleDependencies.catalog.searchProducts(
          request.searchQuery ?? '',
          pageSize: request.pageSize ?? 10,
        ),
      ),
      searchRequestBuilder: (query) => SuperPaginationRequest(
        page: 1,
        pageSize: 10,
        searchQuery: query,
      ),
      searchConfig: const SuperSearchConfig(
        debounceDelay: Duration(milliseconds: 300),
        minSearchLength: 0,
        searchOnEmpty: true,
      ),
      overlayConfig: const SuperSearchOverlayConfig(maxHeight: 220),
      itemBuilder: (context, product) {
        final superTheme = SuperThemeData.of(context);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: superTheme.selectionFill(0.14),
            foregroundColor: Theme.of(context).colorScheme.primary,
            child: Text(product.name[0].toUpperCase()),
          ),
          title: Text(product.name),
          subtitle: Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: context.superTextTheme.mono.copyWith(color: superTheme.tokens.success),
          ),
        );
      },
      onSelected: (product, _) {},
    );
  }

  ThemeData _themeFor(
    BuildContext context, {
    required SuperPalette palette,
    required SuperDeviceMode mode,
  }) {
    final brightness = switch (_themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => MediaQuery.platformBrightnessOf(context),
    };
    final typography = SuperTextTheme(
      isDesktop: mode == SuperDeviceMode.desktop,
    );

    return brightness == Brightness.dark
        ? SuperMaterialThemeData.dark(
            palette: palette,
            mode: mode,
            textTheme: typography,
            primaryTextTheme: typography,
            extensions: [SuperSearchTheme.dark(palette: palette)],
          )
        : SuperMaterialThemeData.light(
            palette: palette,
            mode: mode,
            textTheme: typography,
            primaryTextTheme: typography,
            extensions: [SuperSearchTheme.light(palette: palette)],
          );
  }

  IconData get _themeIcon => switch (_themeMode) {
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
        ThemeMode.system => Icons.brightness_auto,
      };
}

class _PaletteSearchSection extends StatelessWidget {
  const _PaletteSearchSection({
    required this.title,
    required this.subtitle,
    required this.marker,
    required this.palette,
    required this.theme,
    required this.child,
  });

  final String title;
  final String subtitle;
  final SuperMarker marker;
  final SuperPalette palette;
  final ThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          final superTheme = SuperThemeData.of(context);
          return SuperSectionCard(
            header: SuperSectionHeader(
              title: title,
              subtitle: subtitle,
              marker: marker,
              trailing: StatusPill(palette.name, tone: PillTone.accent),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: superTheme.spacing.xs),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _ThemeModeItem extends StatelessWidget {
  const _ThemeModeItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: SuperThemeData.of(context).spacing.space2),
        Text(label),
      ],
    );
  }
}

class _PropertyGroups extends StatelessWidget {
  const _PropertyGroups();

  static const groups = <String, List<String>>{
    'Search box': [
      'searchBoxBackgroundColor',
      'searchBoxTextColor',
      'searchBoxBorderColor',
      'searchBoxFocusedBorderColor',
    ],
    'Overlay and items': [
      'overlayBackgroundColor',
      'overlayBorderColor',
      'itemHoverColor',
      'itemSelectedColor',
    ],
    'States': [
      'loadingIndicatorColor',
      'emptyStateIconColor',
      'errorIconColor',
      'errorButtonColor',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final superTheme = SuperThemeData.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: superTheme.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key.toUpperCase(),
                style: context.superTextTheme.label.copyWith(color: superTheme.fg2),
              ),
              SizedBox(height: superTheme.spacing.sm),
              Wrap(
                spacing: superTheme.spacing.xs,
                runSpacing: superTheme.spacing.xs,
                children: entry.value.map((property) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: superTheme.spacing.space2,
                      vertical: superTheme.spacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: superTheme.inputBg,
                      borderRadius: BorderRadius.circular(
                        superTheme.spacing.radiusControl,
                      ),
                      border: Border.all(color: superTheme.border),
                    ),
                    child: Text(
                      property,
                      style: context.superTextTheme.mono.copyWith(
                        color: superTheme.fg3,
                        fontSize: 10,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
