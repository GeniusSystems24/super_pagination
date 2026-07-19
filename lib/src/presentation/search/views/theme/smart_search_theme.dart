part of '../../search_feature.dart';

/// Theme extension for SuperSearch widgets.
///
/// This extension provides customizable theming for all SuperSearch components
/// including the search box, overlay dropdown, and result items.
///
/// ## Usage
///
/// Install the shared GeniusLink Material theme and the search widgets derive
/// their defaults automatically:
///
/// ```dart
/// MaterialApp(
///   theme: SuperMaterialThemeData.light(),
///   darkTheme: SuperMaterialThemeData.dark(),
/// )
/// ```
///
/// Register a [SuperSearchTheme] extension only when a local override is needed.
///
/// Or create a custom theme:
///
/// ```dart
/// SuperSearchTheme(
///   searchBoxBackgroundColor: Colors.grey[100],
///   searchBoxTextColor: Colors.black87,
///   // ... other properties
/// )
/// ```
class SuperSearchTheme extends ThemeExtension<SuperSearchTheme> {
  /// Creates a SuperSearchTheme with the given properties.
  const SuperSearchTheme({
    // Search Box
    this.searchBoxBackgroundColor,
    this.searchBoxTextColor,
    this.searchBoxHintColor,
    this.searchBoxBorderColor,
    this.searchBoxFocusedBorderColor,
    this.searchBoxIconColor,
    this.searchBoxCursorColor,
    this.searchBoxBorderRadius,
    this.searchBoxElevation,
    this.searchBoxShadowColor,

    // Overlay
    this.overlayBackgroundColor,
    this.overlayBorderColor,
    this.overlayBorderRadius,
    this.overlayElevation,
    this.overlayShadowColor,

    // Items
    this.itemBackgroundColor,
    this.itemHoverColor,
    this.itemFocusedColor,
    this.itemSelectedColor,
    this.itemTextColor,
    this.itemSubtitleColor,
    this.itemIconColor,
    this.itemDividerColor,

    // States
    this.loadingIndicatorColor,
    this.emptyStateIconColor,
    this.emptyStateTextColor,
    this.errorIconColor,
    this.errorTextColor,
    this.errorButtonColor,

    // Scrollbar
    this.scrollbarColor,
    this.scrollbarThickness,
    this.scrollbarRadius,
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Search Box Properties
  // ─────────────────────────────────────────────────────────────────────────

  /// Background color of the search box.
  final Color? searchBoxBackgroundColor;

  /// Text color in the search box.
  final Color? searchBoxTextColor;

  /// Hint text color in the search box.
  final Color? searchBoxHintColor;

  /// Border color of the search box.
  final Color? searchBoxBorderColor;

  /// Border color when the search box is focused.
  final Color? searchBoxFocusedBorderColor;

  /// Icon color in the search box (prefix/suffix icons).
  final Color? searchBoxIconColor;

  /// Cursor color in the search box.
  final Color? searchBoxCursorColor;

  /// Border radius of the search box.
  final BorderRadius? searchBoxBorderRadius;

  /// Elevation of the search box.
  final double? searchBoxElevation;

  /// Shadow color of the search box.
  final Color? searchBoxShadowColor;

  // ─────────────────────────────────────────────────────────────────────────
  // Overlay Properties
  // ─────────────────────────────────────────────────────────────────────────

  /// Background color of the overlay dropdown.
  final Color? overlayBackgroundColor;

  /// Border color of the overlay dropdown.
  final Color? overlayBorderColor;

  /// Border radius of the overlay dropdown.
  final BorderRadius? overlayBorderRadius;

  /// Elevation of the overlay dropdown.
  final double? overlayElevation;

  /// Shadow color of the overlay dropdown.
  final Color? overlayShadowColor;

  // ─────────────────────────────────────────────────────────────────────────
  // Item Properties
  // ─────────────────────────────────────────────────────────────────────────

  /// Default background color of items.
  final Color? itemBackgroundColor;

  /// Background color when hovering over an item.
  final Color? itemHoverColor;

  /// Background color of the focused item (keyboard navigation).
  final Color? itemFocusedColor;

  /// Background color of the selected item.
  final Color? itemSelectedColor;

  /// Primary text color of items.
  final Color? itemTextColor;

  /// Subtitle/secondary text color of items.
  final Color? itemSubtitleColor;

  /// Icon color in items.
  final Color? itemIconColor;

  /// Divider color between items.
  final Color? itemDividerColor;

  // ─────────────────────────────────────────────────────────────────────────
  // State Properties
  // ─────────────────────────────────────────────────────────────────────────

  /// Color of the loading indicator.
  final Color? loadingIndicatorColor;

  /// Icon color in the empty state.
  final Color? emptyStateIconColor;

  /// Text color in the empty state.
  final Color? emptyStateTextColor;

  /// Icon color in the error state.
  final Color? errorIconColor;

  /// Text color in the error state.
  final Color? errorTextColor;

  /// Button color in the error state (retry button).
  final Color? errorButtonColor;

  // ─────────────────────────────────────────────────────────────────────────
  // Scrollbar Properties
  // ─────────────────────────────────────────────────────────────────────────

  /// Color of the scrollbar.
  final Color? scrollbarColor;

  /// Thickness of the scrollbar.
  final double? scrollbarThickness;

  /// Radius of the scrollbar.
  final Radius? scrollbarRadius;

  // ─────────────────────────────────────────────────────────────────────────
  // Factory Constructors
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates search tokens from the shared GeniusLink design system.
  ///
  /// The resulting extension follows the active `super_core` surfaces, text
  /// ramp, primary palette, semantic error color, radii, and overlay treatment.
  factory SuperSearchTheme.geniusLink({
    required SuperThemeData superTheme,
    required ColorScheme colorScheme,
  }) {
    final selectedFill = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.16),
      superTheme.surface,
    );
    final focusedFill = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.10),
      superTheme.surface,
    );

    return SuperSearchTheme(
      // Search box
      searchBoxBackgroundColor: superTheme.inputBg,
      searchBoxTextColor: superTheme.fg1,
      searchBoxHintColor: superTheme.fg4,
      searchBoxBorderColor: superTheme.border,
      searchBoxFocusedBorderColor: colorScheme.primary,
      searchBoxIconColor: superTheme.fg3,
      searchBoxCursorColor: colorScheme.primary,
      searchBoxBorderRadius:
          BorderRadius.circular(superTheme.tokens.radiusControl),
      searchBoxElevation: 0,
      searchBoxShadowColor: Colors.transparent,

      // Overlay
      overlayBackgroundColor: superTheme.surface,
      overlayBorderColor: superTheme.borderStrong,
      overlayBorderRadius: BorderRadius.circular(superTheme.tokens.radiusCard),
      overlayElevation: 0,
      overlayShadowColor: SuperThemeData.popShadow.first.color,

      // Items
      itemBackgroundColor: Colors.transparent,
      itemHoverColor: superTheme.hover,
      itemFocusedColor: focusedFill,
      itemSelectedColor: selectedFill,
      itemTextColor: superTheme.fg1,
      itemSubtitleColor: superTheme.fg3,
      itemIconColor: superTheme.fg3,
      itemDividerColor: superTheme.border,

      // States
      loadingIndicatorColor: colorScheme.primary,
      emptyStateIconColor: superTheme.fg4,
      emptyStateTextColor: superTheme.fg3,
      errorIconColor: colorScheme.error,
      errorTextColor: superTheme.fg3,
      errorButtonColor: colorScheme.primary,

      // Scrollbar
      scrollbarColor: superTheme.borderStrong,
      scrollbarThickness: 6,
      scrollbarRadius: Radius.circular(superTheme.tokens.radiusControl),
    );
  }

  /// Creates the default GeniusLink light search theme.
  factory SuperSearchTheme.light({
    SuperPalette palette = SuperPalette.bluePalette,
  }) {
    return SuperSearchTheme.geniusLink(
      superTheme: SuperThemeData.light,
      colorScheme: palette.toLightColorScheme(),
    );
  }

  /// Creates the default GeniusLink dark search theme.
  factory SuperSearchTheme.dark({
    SuperPalette palette = SuperPalette.bluePalette,
  }) {
    return SuperSearchTheme.geniusLink(
      superTheme: SuperThemeData.dark,
      colorScheme: palette.toDarkColorScheme(),
    );
  }

  /// Gets the [SuperSearchTheme] from the current context.
  ///
  /// When no explicit override is registered, values are derived from the
  /// ambient [SuperMaterialThemeData] / [SuperThemeData] automatically.
  static SuperSearchTheme of(BuildContext context) {
    final materialTheme = Theme.of(context);
    return materialTheme.extension<SuperSearchTheme>() ??
        SuperSearchTheme.geniusLink(
          superTheme: SuperThemeData.of(context),
          colorScheme: materialTheme.colorScheme,
        );
  }

  /// Gets the SuperSearchTheme from the current context, or null if not found.
  static SuperSearchTheme? maybeOf(BuildContext context) {
    return Theme.of(context).extension<SuperSearchTheme>();
  }

  @override
  SuperSearchTheme copyWith({
    // Search Box
    Color? searchBoxBackgroundColor,
    Color? searchBoxTextColor,
    Color? searchBoxHintColor,
    Color? searchBoxBorderColor,
    Color? searchBoxFocusedBorderColor,
    Color? searchBoxIconColor,
    Color? searchBoxCursorColor,
    BorderRadius? searchBoxBorderRadius,
    double? searchBoxElevation,
    Color? searchBoxShadowColor,

    // Overlay
    Color? overlayBackgroundColor,
    Color? overlayBorderColor,
    BorderRadius? overlayBorderRadius,
    double? overlayElevation,
    Color? overlayShadowColor,

    // Items
    Color? itemBackgroundColor,
    Color? itemHoverColor,
    Color? itemFocusedColor,
    Color? itemSelectedColor,
    Color? itemTextColor,
    Color? itemSubtitleColor,
    Color? itemIconColor,
    Color? itemDividerColor,

    // States
    Color? loadingIndicatorColor,
    Color? emptyStateIconColor,
    Color? emptyStateTextColor,
    Color? errorIconColor,
    Color? errorTextColor,
    Color? errorButtonColor,

    // Scrollbar
    Color? scrollbarColor,
    double? scrollbarThickness,
    Radius? scrollbarRadius,
  }) {
    return SuperSearchTheme(
      searchBoxBackgroundColor:
          searchBoxBackgroundColor ?? this.searchBoxBackgroundColor,
      searchBoxTextColor: searchBoxTextColor ?? this.searchBoxTextColor,
      searchBoxHintColor: searchBoxHintColor ?? this.searchBoxHintColor,
      searchBoxBorderColor: searchBoxBorderColor ?? this.searchBoxBorderColor,
      searchBoxFocusedBorderColor:
          searchBoxFocusedBorderColor ?? this.searchBoxFocusedBorderColor,
      searchBoxIconColor: searchBoxIconColor ?? this.searchBoxIconColor,
      searchBoxCursorColor: searchBoxCursorColor ?? this.searchBoxCursorColor,
      searchBoxBorderRadius:
          searchBoxBorderRadius ?? this.searchBoxBorderRadius,
      searchBoxElevation: searchBoxElevation ?? this.searchBoxElevation,
      searchBoxShadowColor: searchBoxShadowColor ?? this.searchBoxShadowColor,
      overlayBackgroundColor:
          overlayBackgroundColor ?? this.overlayBackgroundColor,
      overlayBorderColor: overlayBorderColor ?? this.overlayBorderColor,
      overlayBorderRadius: overlayBorderRadius ?? this.overlayBorderRadius,
      overlayElevation: overlayElevation ?? this.overlayElevation,
      overlayShadowColor: overlayShadowColor ?? this.overlayShadowColor,
      itemBackgroundColor: itemBackgroundColor ?? this.itemBackgroundColor,
      itemHoverColor: itemHoverColor ?? this.itemHoverColor,
      itemFocusedColor: itemFocusedColor ?? this.itemFocusedColor,
      itemSelectedColor: itemSelectedColor ?? this.itemSelectedColor,
      itemTextColor: itemTextColor ?? this.itemTextColor,
      itemSubtitleColor: itemSubtitleColor ?? this.itemSubtitleColor,
      itemIconColor: itemIconColor ?? this.itemIconColor,
      itemDividerColor: itemDividerColor ?? this.itemDividerColor,
      loadingIndicatorColor:
          loadingIndicatorColor ?? this.loadingIndicatorColor,
      emptyStateIconColor: emptyStateIconColor ?? this.emptyStateIconColor,
      emptyStateTextColor: emptyStateTextColor ?? this.emptyStateTextColor,
      errorIconColor: errorIconColor ?? this.errorIconColor,
      errorTextColor: errorTextColor ?? this.errorTextColor,
      errorButtonColor: errorButtonColor ?? this.errorButtonColor,
      scrollbarColor: scrollbarColor ?? this.scrollbarColor,
      scrollbarThickness: scrollbarThickness ?? this.scrollbarThickness,
      scrollbarRadius: scrollbarRadius ?? this.scrollbarRadius,
    );
  }

  @override
  SuperSearchTheme lerp(ThemeExtension<SuperSearchTheme>? other, double t) {
    if (other is! SuperSearchTheme) return this;

    return SuperSearchTheme(
      searchBoxBackgroundColor: Color.lerp(
          searchBoxBackgroundColor, other.searchBoxBackgroundColor, t),
      searchBoxTextColor:
          Color.lerp(searchBoxTextColor, other.searchBoxTextColor, t),
      searchBoxHintColor:
          Color.lerp(searchBoxHintColor, other.searchBoxHintColor, t),
      searchBoxBorderColor:
          Color.lerp(searchBoxBorderColor, other.searchBoxBorderColor, t),
      searchBoxFocusedBorderColor: Color.lerp(
          searchBoxFocusedBorderColor, other.searchBoxFocusedBorderColor, t),
      searchBoxIconColor:
          Color.lerp(searchBoxIconColor, other.searchBoxIconColor, t),
      searchBoxCursorColor:
          Color.lerp(searchBoxCursorColor, other.searchBoxCursorColor, t),
      searchBoxBorderRadius:
          BorderRadius.lerp(searchBoxBorderRadius, other.searchBoxBorderRadius, t),
      searchBoxElevation:
          lerpDouble(searchBoxElevation, other.searchBoxElevation, t),
      searchBoxShadowColor:
          Color.lerp(searchBoxShadowColor, other.searchBoxShadowColor, t),
      overlayBackgroundColor:
          Color.lerp(overlayBackgroundColor, other.overlayBackgroundColor, t),
      overlayBorderColor:
          Color.lerp(overlayBorderColor, other.overlayBorderColor, t),
      overlayBorderRadius:
          BorderRadius.lerp(overlayBorderRadius, other.overlayBorderRadius, t),
      overlayElevation: lerpDouble(overlayElevation, other.overlayElevation, t),
      overlayShadowColor:
          Color.lerp(overlayShadowColor, other.overlayShadowColor, t),
      itemBackgroundColor:
          Color.lerp(itemBackgroundColor, other.itemBackgroundColor, t),
      itemHoverColor: Color.lerp(itemHoverColor, other.itemHoverColor, t),
      itemFocusedColor: Color.lerp(itemFocusedColor, other.itemFocusedColor, t),
      itemSelectedColor:
          Color.lerp(itemSelectedColor, other.itemSelectedColor, t),
      itemTextColor: Color.lerp(itemTextColor, other.itemTextColor, t),
      itemSubtitleColor:
          Color.lerp(itemSubtitleColor, other.itemSubtitleColor, t),
      itemIconColor: Color.lerp(itemIconColor, other.itemIconColor, t),
      itemDividerColor: Color.lerp(itemDividerColor, other.itemDividerColor, t),
      loadingIndicatorColor:
          Color.lerp(loadingIndicatorColor, other.loadingIndicatorColor, t),
      emptyStateIconColor:
          Color.lerp(emptyStateIconColor, other.emptyStateIconColor, t),
      emptyStateTextColor:
          Color.lerp(emptyStateTextColor, other.emptyStateTextColor, t),
      errorIconColor: Color.lerp(errorIconColor, other.errorIconColor, t),
      errorTextColor: Color.lerp(errorTextColor, other.errorTextColor, t),
      errorButtonColor: Color.lerp(errorButtonColor, other.errorButtonColor, t),
      scrollbarColor: Color.lerp(scrollbarColor, other.scrollbarColor, t),
      scrollbarThickness:
          lerpDouble(scrollbarThickness, other.scrollbarThickness, t),
      scrollbarRadius: Radius.lerp(scrollbarRadius, other.scrollbarRadius, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SuperSearchTheme) return false;

    return searchBoxBackgroundColor == other.searchBoxBackgroundColor &&
        searchBoxTextColor == other.searchBoxTextColor &&
        searchBoxHintColor == other.searchBoxHintColor &&
        searchBoxBorderColor == other.searchBoxBorderColor &&
        searchBoxFocusedBorderColor == other.searchBoxFocusedBorderColor &&
        searchBoxIconColor == other.searchBoxIconColor &&
        searchBoxCursorColor == other.searchBoxCursorColor &&
        searchBoxBorderRadius == other.searchBoxBorderRadius &&
        searchBoxElevation == other.searchBoxElevation &&
        searchBoxShadowColor == other.searchBoxShadowColor &&
        overlayBackgroundColor == other.overlayBackgroundColor &&
        overlayBorderColor == other.overlayBorderColor &&
        overlayBorderRadius == other.overlayBorderRadius &&
        overlayElevation == other.overlayElevation &&
        overlayShadowColor == other.overlayShadowColor &&
        itemBackgroundColor == other.itemBackgroundColor &&
        itemHoverColor == other.itemHoverColor &&
        itemFocusedColor == other.itemFocusedColor &&
        itemSelectedColor == other.itemSelectedColor &&
        itemTextColor == other.itemTextColor &&
        itemSubtitleColor == other.itemSubtitleColor &&
        itemIconColor == other.itemIconColor &&
        itemDividerColor == other.itemDividerColor &&
        loadingIndicatorColor == other.loadingIndicatorColor &&
        emptyStateIconColor == other.emptyStateIconColor &&
        emptyStateTextColor == other.emptyStateTextColor &&
        errorIconColor == other.errorIconColor &&
        errorTextColor == other.errorTextColor &&
        errorButtonColor == other.errorButtonColor &&
        scrollbarColor == other.scrollbarColor &&
        scrollbarThickness == other.scrollbarThickness &&
        scrollbarRadius == other.scrollbarRadius;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      searchBoxBackgroundColor,
      searchBoxTextColor,
      searchBoxHintColor,
      searchBoxBorderColor,
      searchBoxFocusedBorderColor,
      searchBoxIconColor,
      searchBoxCursorColor,
      searchBoxBorderRadius,
      searchBoxElevation,
      searchBoxShadowColor,
      overlayBackgroundColor,
      overlayBorderColor,
      overlayBorderRadius,
      overlayElevation,
      overlayShadowColor,
      itemBackgroundColor,
      itemHoverColor,
      itemFocusedColor,
      itemSelectedColor,
      itemTextColor,
      itemSubtitleColor,
      itemIconColor,
      itemDividerColor,
      loadingIndicatorColor,
      emptyStateIconColor,
      emptyStateTextColor,
      errorIconColor,
      errorTextColor,
      errorButtonColor,
      scrollbarColor,
      scrollbarThickness,
      scrollbarRadius,
    ]);
  }
}
