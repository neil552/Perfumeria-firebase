import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../data/catalog_repository.dart';
import '../data/favorites_repository.dart';
import '../data/product_model.dart';
import 'product_detail_page.dart';

/// Presenta los productos guardados y permite abrirlos o quitarlos de favoritos.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<Set<int>>(
          valueListenable: FavoritesRepository.productIds,
          builder: (context, ids, _) {
            final products = CatalogRepository.products
                .where((product) => ids.contains(product.id))
                .toList();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AppHeader(
                    title: 'Mis favoritos',
                    onBack: () => Navigator.pop(context),
                  ),
                ),
                if (products.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppIcon(
                              'heart',
                              size: 38,
                              color: AppTheme.wine,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Aún no tienes favoritos',
                              style: AppTheme.playfair(
                                size: 21,
                                weight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Guarda productos con el corazón para encontrarlos aquí.',
                              textAlign: TextAlign.center,
                              style: AppTheme.poppins(
                                size: 11,
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _FavoriteProduct(
                          product: product,
                          onOpen: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  ProductDetailPage(product: product),
                            ),
                          ),
                          onRemove: () =>
                              FavoritesRepository.toggle(product.id),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Fila de favorito con acceso al detalle y acción para quitarlo de la lista.
class _FavoriteProduct extends StatelessWidget {
  const _FavoriteProduct({
    required this.product,
    required this.onOpen,
    required this.onRemove,
  });

  final Product product;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 90,
                  height: 100,
                  child: AppImage(url: product.image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTheme.poppins(
                        size: 12,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.category,
                      style: AppTheme.poppins(size: 9, color: AppTheme.muted),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'S/ ${product.price.toStringAsFixed(2)}',
                      style: AppTheme.poppins(
                        size: 11,
                        weight: FontWeight.w600,
                        color: AppTheme.wine,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Quitar de favoritos',
                onPressed: onRemove,
                icon: const AppIcon('heart', color: AppTheme.wine),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
