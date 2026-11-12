import 'package:flutter/material.dart';

import '../../../../app/config/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_image.dart';
import '../../data/product_model.dart';

/// Tarjeta de producto reutilizable.
///
/// Equivale al componente `ProductCard` del proyecto React original.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.imageHeight = 166,
  });

  final Product product;
  final VoidCallback onTap;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: AppTheme.plum.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AppImage(url: product.image, fit: BoxFit.cover),
                  ),
                  if (product.badge != null)
                    Positioned(
                      left: 9,
                      top: 9,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.wine,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.badge!,
                          style: AppTheme.poppins(
                            size: 8,
                            weight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 29,
                      height: 29,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.87),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const AppIcon('heart', size: 16, color: AppTheme.wine),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(11, 11, 11, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.category,
                    style: AppTheme.poppins(size: 8, color: AppTheme.muted),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.poppins(
                      size: 11,
                      weight: FontWeight.w500,
                      color: AppTheme.plum,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        soles(product.price),
                        style: AppTheme.poppins(
                          size: 12,
                          weight: FontWeight.w600,
                          color: AppTheme.wine,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 7),
                        Text(
                          soles(product.oldPrice!),
                          style: AppTheme.poppins(
                            size: 8,
                            color: const Color(0xFFAA999F),
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
