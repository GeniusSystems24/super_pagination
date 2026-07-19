part of '../../pagination_feature.dart';

/// A customizable error widget builder for pagination errors.
///
/// Every built-in style reads [SuperPaginationTheme] and the shared
/// GeniusLink tokens. Existing parameters remain available as local overrides.
class CustomErrorBuilder {
  static Widget material({
    required BuildContext context,
    required Exception error,
    required VoidCallback onRetry,
    String? title,
    String? message,
    IconData? icon,
    Color? iconColor,
    String? retryButtonText,
  }) {
    final paginationTheme = SuperPaginationTheme.of(context);
    final superTheme = SuperThemeData.of(context);

    return Center(
      child: Padding(
        padding: superTheme.padding.card,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: superTheme.sizing.contentColumn),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.error_outline_rounded,
                color: iconColor ?? paginationTheme.errorIconColor,
                size: 48,
              ),
              SizedBox(height: superTheme.spacing.lg),
              Text(
                title ?? 'Something went wrong',
                style: SuperText.heading.copyWith(
                  color: paginationTheme.errorTitleColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: superTheme.spacing.sm),
              Text(
                message ?? error.toString(),
                textAlign: TextAlign.center,
                style: SuperText.body.copyWith(
                  color: paginationTheme.errorMessageColor,
                ),
              ),
              SizedBox(height: superTheme.spacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(retryButtonText ?? 'Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget compact({
    required BuildContext context,
    required Exception error,
    required VoidCallback onRetry,
    String? message,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final paginationTheme = SuperPaginationTheme.of(context);
    final superTheme = SuperThemeData.of(context);
    final effectiveTextColor = textColor ?? paginationTheme.errorIconColor;

    return Container(
      margin: EdgeInsets.all(superTheme.spacing.md),
      padding: EdgeInsets.all(superTheme.spacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? paginationTheme.errorContainerColor,
        borderRadius: BorderRadius.circular(superTheme.tokens.radiusCard),
        border: Border.all(color: paginationTheme.errorBorderColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: effectiveTextColor,
            size: superTheme.sizing.icon,
          ),
          SizedBox(width: superTheme.spacing.md),
          Expanded(
            child: Text(
              message ?? 'Failed to load more items',
              style: SuperText.body.copyWith(color: effectiveTextColor),
            ),
          ),
          SizedBox(width: superTheme.spacing.sm),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }

  static Widget minimal({
    required BuildContext context,
    required Exception error,
    required VoidCallback onRetry,
    String? message,
  }) {
    final paginationTheme = SuperPaginationTheme.of(context);
    final superTheme = SuperThemeData.of(context);

    return Padding(
      padding: EdgeInsets.all(superTheme.spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              message ?? 'Error occurred',
              style: SuperText.caption.copyWith(
                color: paginationTheme.errorMessageColor,
              ),
            ),
          ),
          SizedBox(width: superTheme.spacing.xs),
          IconButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Retry',
          ),
        ],
      ),
    );
  }

  static Widget custom({
    required BuildContext context,
    required Exception error,
    required VoidCallback onRetry,
    required Widget Function(
      BuildContext context,
      Exception error,
      VoidCallback onRetry,
    ) builder,
  }) {
    return builder(context, error, onRetry);
  }

  static Widget card({
    required BuildContext context,
    required Exception error,
    required VoidCallback onRetry,
    String? title,
    String? message,
    double? elevation,
  }) {
    final paginationTheme = SuperPaginationTheme.of(context);
    final superTheme = SuperThemeData.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: superTheme.sizing.contentColumn),
        child: Card(
          elevation: elevation ?? 0,
          margin: EdgeInsets.all(superTheme.spacing.md),
          color: superTheme.surface,
          shadowColor: Theme.of(context).shadowColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(superTheme.tokens.radiusCard),
            side: BorderSide(color: superTheme.border),
          ),
          child: Padding(
            padding: superTheme.padding.card,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: superTheme.tokens.warning,
                  size: 40,
                ),
                SizedBox(height: superTheme.spacing.md),
                Text(
                  title ?? 'Error Loading Data',
                  style: SuperText.heading.copyWith(
                    color: paginationTheme.errorTitleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: superTheme.spacing.sm),
                Text(
                  message ?? 'An error occurred while loading the data.',
                  textAlign: TextAlign.center,
                  style: SuperText.body.copyWith(
                    color: paginationTheme.errorMessageColor,
                  ),
                ),
                SizedBox(height: superTheme.spacing.lg),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget snackbar({
    required BuildContext context,
    required Exception error,
    required VoidCallback onRetry,
    String? message,
    Color? backgroundColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final superTheme = SuperThemeData.of(context);
    final foreground = colorScheme.onInverseSurface;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.all(superTheme.spacing.md),
        padding: EdgeInsets.symmetric(
          horizontal: superTheme.spacing.md,
          vertical: superTheme.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(superTheme.tokens.radiusCard),
          boxShadow: SuperThemeData.popShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: foreground, size: 20),
            SizedBox(width: superTheme.spacing.sm),
            Flexible(
              child: Text(
                message ?? 'Failed to load',
                style: SuperText.body.copyWith(color: foreground),
              ),
            ),
            SizedBox(width: superTheme.spacing.sm),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(foregroundColor: foreground),
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}
