part of '../../pagination_feature.dart';

/// GeniusLink-aligned visual tokens for the built-in pagination states.
///
/// Defaults are derived from `super_core`, so pagination loaders, empty states,
/// and errors automatically follow the active [SuperMaterialThemeData] palette,
/// brightness, and responsive metrics. Applications may still register a
/// customized extension in [ThemeData.extensions].
@immutable
class SuperPaginationTheme extends ThemeExtension<SuperPaginationTheme> {
  const SuperPaginationTheme({
    required this.loadingIndicatorColor,
    required this.emptyIconColor,
    required this.emptyTitleColor,
    required this.emptyMessageColor,
    required this.errorIconColor,
    required this.errorTitleColor,
    required this.errorMessageColor,
    required this.errorContainerColor,
    required this.errorBorderColor,
    required this.retryButtonColor,
    required this.retryButtonForegroundColor,
  });

  final Color loadingIndicatorColor;
  final Color emptyIconColor;
  final Color emptyTitleColor;
  final Color emptyMessageColor;
  final Color errorIconColor;
  final Color errorTitleColor;
  final Color errorMessageColor;
  final Color errorContainerColor;
  final Color errorBorderColor;
  final Color retryButtonColor;
  final Color retryButtonForegroundColor;

  /// Builds pagination tokens from the shared GeniusLink theme.
  factory SuperPaginationTheme.geniusLink({
    required SuperThemeData superTheme,
    required ColorScheme colorScheme,
  }) {
    return SuperPaginationTheme(
      loadingIndicatorColor: colorScheme.primary,
      emptyIconColor: superTheme.fg4,
      emptyTitleColor: superTheme.fg2,
      emptyMessageColor: superTheme.fg3,
      errorIconColor: colorScheme.error,
      errorTitleColor: superTheme.fg1,
      errorMessageColor: superTheme.fg3,
      errorContainerColor: superTheme.tint(colorScheme.error, 0.10),
      errorBorderColor: Color.alphaBlend(
        colorScheme.error.withValues(alpha: 0.42),
        superTheme.border,
      ),
      retryButtonColor: colorScheme.primary,
      retryButtonForegroundColor: colorScheme.onPrimary,
    );
  }

  factory SuperPaginationTheme.light({
    SuperPalette palette = SuperPalette.bluePalette,
  }) {
    return SuperPaginationTheme.geniusLink(
      superTheme: SuperThemeData.light,
      colorScheme: palette.toLightColorScheme(),
    );
  }

  factory SuperPaginationTheme.dark({
    SuperPalette palette = SuperPalette.bluePalette,
  }) {
    return SuperPaginationTheme.geniusLink(
      superTheme: SuperThemeData.dark,
      colorScheme: palette.toDarkColorScheme(),
    );
  }

  static SuperPaginationTheme of(BuildContext context) {
    final materialTheme = Theme.of(context);
    return materialTheme.extension<SuperPaginationTheme>() ??
        SuperPaginationTheme.geniusLink(
          superTheme: SuperThemeData.of(context),
          colorScheme: materialTheme.colorScheme,
        );
  }

  static SuperPaginationTheme? maybeOf(BuildContext context) =>
      Theme.of(context).extension<SuperPaginationTheme>();

  @override
  SuperPaginationTheme copyWith({
    Color? loadingIndicatorColor,
    Color? emptyIconColor,
    Color? emptyTitleColor,
    Color? emptyMessageColor,
    Color? errorIconColor,
    Color? errorTitleColor,
    Color? errorMessageColor,
    Color? errorContainerColor,
    Color? errorBorderColor,
    Color? retryButtonColor,
    Color? retryButtonForegroundColor,
  }) {
    return SuperPaginationTheme(
      loadingIndicatorColor:
          loadingIndicatorColor ?? this.loadingIndicatorColor,
      emptyIconColor: emptyIconColor ?? this.emptyIconColor,
      emptyTitleColor: emptyTitleColor ?? this.emptyTitleColor,
      emptyMessageColor: emptyMessageColor ?? this.emptyMessageColor,
      errorIconColor: errorIconColor ?? this.errorIconColor,
      errorTitleColor: errorTitleColor ?? this.errorTitleColor,
      errorMessageColor: errorMessageColor ?? this.errorMessageColor,
      errorContainerColor: errorContainerColor ?? this.errorContainerColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      retryButtonColor: retryButtonColor ?? this.retryButtonColor,
      retryButtonForegroundColor:
          retryButtonForegroundColor ?? this.retryButtonForegroundColor,
    );
  }

  @override
  SuperPaginationTheme lerp(
    ThemeExtension<SuperPaginationTheme>? other,
    double t,
  ) {
    if (other is! SuperPaginationTheme) return this;
    return SuperPaginationTheme(
      loadingIndicatorColor:
          Color.lerp(loadingIndicatorColor, other.loadingIndicatorColor, t)!,
      emptyIconColor: Color.lerp(emptyIconColor, other.emptyIconColor, t)!,
      emptyTitleColor: Color.lerp(emptyTitleColor, other.emptyTitleColor, t)!,
      emptyMessageColor:
          Color.lerp(emptyMessageColor, other.emptyMessageColor, t)!,
      errorIconColor: Color.lerp(errorIconColor, other.errorIconColor, t)!,
      errorTitleColor: Color.lerp(errorTitleColor, other.errorTitleColor, t)!,
      errorMessageColor:
          Color.lerp(errorMessageColor, other.errorMessageColor, t)!,
      errorContainerColor:
          Color.lerp(errorContainerColor, other.errorContainerColor, t)!,
      errorBorderColor:
          Color.lerp(errorBorderColor, other.errorBorderColor, t)!,
      retryButtonColor:
          Color.lerp(retryButtonColor, other.retryButtonColor, t)!,
      retryButtonForegroundColor: Color.lerp(
        retryButtonForegroundColor,
        other.retryButtonForegroundColor,
        t,
      )!,
    );
  }
}
