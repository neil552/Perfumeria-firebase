import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../app/constants/app_constants.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/section_heading.dart';
import '../../cart/data/cart_repository.dart';
import '../../catalog/data/catalog_repository.dart';
import '../../catalog/data/product_model.dart';
import '../../catalog/presentation/product_detail_page.dart';
import '../../catalog/presentation/widgets/product_card.dart';
import '../data/promotions_repository.dart';

/// Pantalla de promociones.
///
/// Equivale al componente `Promotions` del proyecto React original.
class PromotionsPage extends StatelessWidget {
  const PromotionsPage({super.key});

  void _go(BuildContext context, String route) =>
      Navigator.pushReplacementNamed(context, route);

  void _open(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
    );
  }

  Future<void> _copyCoupon(BuildContext context) async {
    await Clipboard.setData(
      const ClipboardData(text: PromotionsRepository.couponCode),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cupón ${PromotionsRepository.couponCode} copiado',
          style: AppTheme.poppins(size: 12, color: Colors.white),
        ),
        backgroundColor: AppTheme.plum,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final discounted = CatalogRepository.discounted;
    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        current: AppRoutes.promotions,
        onNavigate: (route) => _go(context, route),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<List<CartItem>>(
                valueListenable: CartRepository.instance.items,
                builder: (context, items, child) => AppHeader(
                  title: 'Promociones',
                  cartCount: CartRepository.instance.count,
                  onCart: () => Navigator.pushNamed(context, AppRoutes.cart),
                ),
              ),
              const SizedBox(height: 4),
              _buildHero(),
              const SizedBox(height: 28),
              const SectionHeading(
                eyebrow: 'OPORTUNIDADES ESPECIALES',
                title: 'Promociones para ti',
              ),
              const SizedBox(height: 14),
              _buildGrid(context, discounted),
              const SizedBox(height: 20),
              _buildCoupon(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const AppImage(url: AppImages.bouquet, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xDA37232F),
                  Color(0x9B4D3441),
                  Colors.transparent,
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PromotionsRepository.heroEyebrow,
                  style: AppTheme.poppins(
                    size: 8,
                    weight: FontWeight.w600,
                    color: const Color(0xFFEFD294),
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 7),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Momentos que\n'),
                      TextSpan(
                        text: 'merecen celebrarse',
                        style: AppTheme.playfair(
                          size: 27,
                          weight: FontWeight.w600,
                          color: const Color(0xFFEDCCDA),
                          height: 1.1,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  style: AppTheme.playfair(
                    size: 27,
                    weight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 7),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 190),
                  child: Text(
                    'Hasta 20% de descuento en detalles seleccionados.',
                    style: AppTheme.poppins(size: 9, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Product> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final product in products)
              SizedBox(
                width: itemWidth,
                child: ProductCard(
                  product: product,
                  imageHeight: 180,
                  onTap: () => _open(context, product),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCoupon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF45323B),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          const AppIcon('tag', size: 24, color: AppTheme.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PromotionsRepository.couponLabel,
                  style: AppTheme.poppins(
                    size: 7,
                    color: const Color(0xFFDFC083),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  PromotionsRepository.couponCode,
                  style: AppTheme.poppins(
                    size: 13,
                    weight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  PromotionsRepository.couponDescription,
                  style: AppTheme.poppins(
                    size: 7,
                    color: const Color(0xFFD8CBD0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _copyCoupon(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x54FFFFFF)),
              ),
              child: Text(
                'Copiar',
                style: AppTheme.poppins(size: 8, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
