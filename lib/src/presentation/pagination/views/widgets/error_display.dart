part of '../../pagination_feature.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.exception,
    this.onRetry,
    this.customBuilder,
  });

  final Exception exception;
  final VoidCallback? onRetry;

  /// Custom builder for complete control over error UI.
  /// If provided, this takes precedence over the default error display.
  final Widget Function(
    BuildContext context,
    Exception exception,
    VoidCallback? onRetry,
  )? customBuilder;

  @override
  Widget build(BuildContext context) {
    if (customBuilder != null) {
      return customBuilder!(context, exception, onRetry);
    }

    final paginationTheme = SuperPaginationTheme.of(context);
    final superTheme = SuperThemeData.of(context);

    return Center(
      child: Padding(
        padding: superTheme.spacing.cardPadding,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: superTheme.sizing.contentColumn),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: paginationTheme.errorContainerColor,
              borderRadius: BorderRadius.circular(superTheme.spacing.radiusCard),
              border: Border.all(color: paginationTheme.errorBorderColor),
            ),
            child: Padding(
              padding: superTheme.spacing.cardPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: paginationTheme.errorIconColor,
                    size: 40,
                  ),
                  SizedBox(height: superTheme.spacing.md),
                  Text(
                    'Error occurred',
                    textAlign: TextAlign.center,
                    style: superTheme.textTheme.heading.copyWith(
                      color: paginationTheme.errorTitleColor,
                    ),
                  ),
                  SizedBox(height: superTheme.spacing.sm),
                  Text(
                    exception.toString(),
                    textAlign: TextAlign.center,
                    style: superTheme.textTheme.body.copyWith(
                      color: paginationTheme.errorMessageColor,
                    ),
                  ),
                  if (onRetry != null) ...[
                    SizedBox(height: superTheme.spacing.lg),
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                      style: FilledButton.styleFrom(
                        backgroundColor: paginationTheme.retryButtonColor,
                        foregroundColor:
                            paginationTheme.retryButtonForegroundColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
