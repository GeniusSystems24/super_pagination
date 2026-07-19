import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';
import 'package:super_pagination_example/shared/domain/entities/product.dart';

import 'highlighted_text.dart';

/// A reusable product card that follows the shared GeniusLink visual system.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.searchQuery = '',
    this.onTap,
  });

  final Product product;
  final String searchQuery;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final superTheme = SuperThemeData.of(context);

    return SuperCard(
      margin: EdgeInsets.only(bottom: superTheme.spacing.md),
      padding: EdgeInsets.all(superTheme.spacing.md),
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(superTheme.tokens.radiusMd),
            child: Image.network(
              product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: superTheme.inputBg,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: superTheme.fg4,
                  ),
                );
              },
            ),
          ),
          SizedBox(width: superTheme.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HighlightedText.single(
                  text: product.name,
                  searchQuery: searchQuery,
                  style: SuperText.heading.copyWith(color: superTheme.fg1),
                  highlightColor: superTheme.tintFill(
                    Theme.of(context).colorScheme.primary,
                    0.22,
                  ),
                ),
                SizedBox(height: superTheme.spacing.xs),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: SuperText.caption.copyWith(color: superTheme.fg3),
                ),
                SizedBox(height: superTheme.spacing.sm),
                StatusPill(product.category, tone: PillTone.accent),
              ],
            ),
          ),
          SizedBox(width: superTheme.spacing.md),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: SuperText.mono.copyWith(
              color: superTheme.tokens.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
