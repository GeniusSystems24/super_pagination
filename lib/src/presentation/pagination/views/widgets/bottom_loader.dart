part of '../../pagination_feature.dart';

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final paginationTheme = SuperPaginationTheme.of(context);
    final spacing = SuperThemeData.of(context).spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: spacing.md, bottom: spacing.xl),
        child: SizedBox.square(
          dimension: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: paginationTheme.loadingIndicatorColor,
          ),
        ),
      ),
    );
  }
}
