import 'package:flutter/material.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../app/constants/app_constants.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_heading.dart';
import '../../cart/data/cart_repository.dart';
import '../../catalog/data/catalog_repository.dart';
import '../../catalog/data/product_model.dart';
import '../../catalog/presentation/product_detail_page.dart';
import '../../catalog/presentation/widgets/product_card.dart';

/// Pantalla de inicio.
///
/// Equivale al componente `Home` del proyecto React original.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Coordina las secciones de inicio y la navegación a productos relacionados.
class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  static const List<_Occasion> _occasions = [
    _Occasion('Cumpleaños', 'gift', Color(0xFFF0DEE5), AppTheme.wine),
    _Occasion('Aniversario', 'heart', Color(0xFFF2DFD8), Color(0xFFA75E64)),
    _Occasion('Gracias', 'sparkle', Color(0xFFEEE4CE), Color(0xFF99733E)),
    _Occasion('Celebración', 'tag', Color(0xFFE7DCE1), Color(0xFF6F5360)),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _go(String route) => Navigator.pushReplacementNamed(context, route);

  void _open(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        current: AppRoutes.home,
        onNavigate: _go,
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
                builder: (context, items, _) => AppHeader(
                  cartCount: CartRepository.instance.count,
                  onCart: () => Navigator.pushNamed(context, AppRoutes.cart),
                ),
              ),
              const SizedBox(height: 13),
              _buildGreeting(),
              const SizedBox(height: 20),
              SearchField(
                controller: _searchController,
                hint: 'Buscar regalos, perfumes...',
                onSubmitted: (_) => _go(AppRoutes.catalog),
                trailing: _searchController.text.isNotEmpty
                    ? SearchTrailingButton(
                        icon: 'chevron',
                        onTap: () => _go(AppRoutes.catalog),
                      )
                    : null,
              ),
              const SizedBox(height: 18),
              _buildPromoHero(),
              const SizedBox(height: 13),
              _buildQuickLinks(),
              const SizedBox(height: 28),
              const SectionHeading(
                eyebrow: 'PARA CADA MOMENTO',
                title: 'Encuentra el regalo perfecto',
              ),
              const SizedBox(height: 14),
              _buildOccasions(),
              const SizedBox(height: 28),
              SectionHeading(
                eyebrow: 'NUESTROS FAVORITOS',
                title: 'Productos destacados',
                actionLabel: 'Ver todo',
                onAction: () => _go(AppRoutes.catalog),
              ),
              const SizedBox(height: 14),
              _buildHorizontalProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, Valeria',
                style: AppTheme.poppins(size: 12, color: AppTheme.muted),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '¿A quién vamos a\n',
                      style: AppTheme.playfair(
                        size: 29,
                        weight: FontWeight.w600,
                        height: 1.14,
                      ),
                    ),
                    TextSpan(
                      text: 'sorprender hoy?',
                      style: AppTheme.playfair(
                        size: 29,
                        weight: FontWeight.w500,
                        color: AppTheme.wine,
                        height: 1.14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEAD3DC),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF62404E).withValues(alpha: 0.12),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'VM',
            style: AppTheme.poppins(
              size: 12,
              weight: FontWeight.w600,
              color: AppTheme.wine,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoHero() {
    return GestureDetector(
      onTap: () => _open(CatalogRepository.products[4]),
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppTheme.plum.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AppImage(
              url: AppImages.perfume2,
              fit: BoxFit.cover,
              alignment: Alignment(0.28, -0.16),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xE8472F3D),
                    Color(0xBB50313C),
                    Color(0x0050313C),
                  ],
                  stops: [0.0, 0.46, 0.77],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SEMANA ESPECIAL',
                    style: AppTheme.poppins(
                      size: 8,
                      weight: FontWeight.w700,
                      color: const Color(0xFFE8C990),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Esencias que\ndejan huella',
                    style: AppTheme.playfair(
                      size: 25,
                      weight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hasta 20% dto.',
                    style: AppTheme.poppins(
                      size: 10,
                      color: const Color(0xFFF4DCE5),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(bottom: 3),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white)),
                    ),
                    child: Text(
                      'Descubrir ahora',
                      style: AppTheme.poppins(size: 9, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinks() {
    return Row(
      children: [
        Expanded(
          child: _QuickLink(
            eyebrow: 'Descubre',
            title: 'Regalos',
            icon: 'gift',
            onTap: () => _go(AppRoutes.catalog),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickLink(
            eyebrow: 'Explora',
            title: 'Perfumería',
            icon: 'sparkle',
            onTap: () => _go(AppRoutes.catalog),
          ),
        ),
      ],
    );
  }

  Widget _buildOccasions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final occasion in _occasions)
          GestureDetector(
            onTap: () => _go(AppRoutes.catalog),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Container(
                  width: 59,
                  height: 59,
                  decoration: BoxDecoration(
                    color: occasion.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: AppIcon(
                    occasion.icon,
                    size: 22,
                    color: occasion.foreground,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  occasion.label,
                  style: AppTheme.poppins(size: 10, color: AppTheme.plum),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalProducts() {
    final products = CatalogRepository.featured;
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => SizedBox(
          width: 160,
          child: ProductCard(
            product: products[index],
            onTap: () => _open(products[index]),
          ),
        ),
      ),
    );
  }
}

/// Configuración visual de una ocasión ("Para cada momento").
class _Occasion {
  const _Occasion(this.label, this.icon, this.background, this.foreground);

  final String label;
  final String icon;
  final Color background;
  final Color foreground;
}

/// Enlace rápido con icono usado en la pantalla de inicio.
class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.eyebrow,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String eyebrow;
  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.line),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF1E0E7),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: AppIcon(icon, size: 20, color: AppTheme.wine),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: AppTheme.poppins(size: 8, color: AppTheme.muted),
                  ),
                  Text(
                    title,
                    style: AppTheme.playfair(size: 14, weight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const AppIcon('chevron', size: 18, color: AppTheme.plum),
          ],
        ),
      ),
    );
  }
}
