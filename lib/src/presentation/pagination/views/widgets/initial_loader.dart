part of '../../pagination_feature.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final paginationTheme = SuperPaginationTheme.of(context);
    final superTheme = SuperThemeData.of(context);

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: superTheme.spacing.cardPadding,
          child: SizedBox.square(
            dimension: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: paginationTheme.loadingIndicatorColor,
            ),
          ),
        ),
      ),
    );
  }
}
