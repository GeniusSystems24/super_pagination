part of '../../pagination_feature.dart';

class EmptyDisplay extends StatelessWidget {
  const EmptyDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final paginationTheme = SuperPaginationTheme.of(context);
    final spacing = SuperThemeData.of(context).spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 40,
              color: paginationTheme.emptyIconColor,
            ),
            SizedBox(height: spacing.md),
            Text(
              'No documents found',
              style: SuperText.heading.copyWith(
                color: paginationTheme.emptyTitleColor,
              ),
            ),
            SizedBox(height: spacing.xs),
            Text(
              'New items will appear here when they are available.',
              textAlign: TextAlign.center,
              style: SuperText.caption.copyWith(
                color: paginationTheme.emptyMessageColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
