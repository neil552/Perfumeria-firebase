import 'package:flutter/material.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/custom_button.dart';
import '../../cart/data/cart_repository.dart';
import '../data/favorites_repository.dart';
import '../data/product_model.dart';
import 'customize_page.dart';

/// Pantalla de detalle de producto.
///
/// Equivale al componente `Detail` del proyecto React original.
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

/// Controla la variante, cantidad y avisos de agregado al carrito.
class _ProductDetailPageState extends State<ProductDetailPage> {
  late String _variant;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    _variant = widget.product.isFragrance ? '50 ml' : 'Clásico';
  }

  List<String> get _variants => widget.product.isFragrance
      ? const ['30 ml', '50 ml', '100 ml']
      : const ['Clásico', 'Mediano', 'Grande'];

  String get _variantLabel =>
      widget.product.isFragrance ? 'Presentación' : 'Tamaño';

  void _openCustomize() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomizePage(product: widget.product)),
    );
  }

  void _buy() {
    if (widget.product.customizable) {
      _openCustomize();
      return;
    }
    CartRepository.instance.add(widget.product, variant: _variant);
    setState(() => _added = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _added = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [_buildImage(product), _buildBody(product)],
          ),
          if (_added)
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: _Toast(
                onViewCart: () {
                  setState(() => _added = false);
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(Product product) {
    return SizedBox(
      height: 430,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: AppTheme.line,
              child: AppImage(url: product.image, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            left: 18,
            top: 22,
            child: _FloatingButton(
              icon: 'arrow',
              color: AppTheme.plum,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            right: 18,
            top: 22,
            child: ValueListenableBuilder<Set<int>>(
              valueListenable: FavoritesRepository.productIds,
              builder: (context, favorites, _) => _FloatingButton(
                icon: 'heart',
                color: favorites.contains(product.id)
                    ? AppTheme.wine
                    : AppTheme.plum,
                onTap: () => FavoritesRepository.toggle(product.id),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 17,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(width: 20, active: true),
                const SizedBox(width: 6),
                _dot(width: 6),
                const SizedBox(width: 6),
                _dot(width: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({required double width, bool active = false}) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildBody(Product product) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.category, style: AppTheme.eyebrow()),
          const SizedBox(height: 3),
          Text(
            product.name,
            style: AppTheme.playfair(size: 30, weight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildPrice(product),
          const SizedBox(height: 17),
          Text(
            'Una selección creada para convertir cualquier momento en un recuerdo '
            'especial. Presentación elegante, acabados delicados y una experiencia '
            'que encanta desde el primer instante.',
            style: AppTheme.poppins(
              size: 11,
              color: const Color(0xFF77666D),
              height: 1.75,
            ),
          ),
          const SizedBox(height: 17),
          _buildFeatureRow(),
          const SizedBox(height: 20),
          _buildVariantSection(),
          _buildExpandable(
            'Características',
            'Materiales seleccionados, empaque protegido y presentación '
                'cuidadosamente terminada.',
          ),
          _buildExpandable(
            'Cuidados y entrega',
            'Conservar en un lugar fresco. La fecha y horario de entrega se '
                'seleccionan al confirmar.',
          ),
          if (product.customizable) ...[
            const SizedBox(height: 18),
            _buildCustomizeCallout(),
          ],
          const SizedBox(height: 18),
          PrimaryButton(
            label:
                '${product.customizable ? 'Personalizar y agregar' : 'Agregar al carrito'} · ${soles(product.price)}',
            iconName: 'bag',
            onPressed: _buy,
          ),
        ],
      ),
    );
  }

  Widget _buildPrice(Product product) {
    return Row(
      children: [
        Text(
          soles(product.price),
          style: AppTheme.poppins(
            size: 19,
            weight: FontWeight.w600,
            color: AppTheme.wine,
          ),
        ),
        if (product.oldPrice != null) ...[
          const SizedBox(width: 9),
          Text(
            soles(product.oldPrice!),
            style: AppTheme.poppins(
              size: 11,
              color: const Color(0xFFA7959C),
            ).copyWith(decoration: TextDecoration.lineThrough),
          ),
          const SizedBox(width: 9),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E2CE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Ahorras ${soles(product.oldPrice! - product.price)}',
              style: AppTheme.poppins(size: 8, color: const Color(0xFF86642E)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureRow() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _featureIcon('check'),
          const SizedBox(width: 8),
          Expanded(child: _featureText('Disponible', 'Entrega desde mañana')),
          const SizedBox(width: 8),
          _featureIcon('gift'),
          const SizedBox(width: 8),
          Expanded(
            child: _featureText('Presentación premium', 'Lista para regalar'),
          ),
        ],
      ),
    );
  }

  Widget _featureIcon(String icon) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: const Color(0xFFF2E2E8),
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: AppIcon(icon, size: 16, color: AppTheme.wine),
    );
  }

  Widget _featureText(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppTheme.poppins(size: 9, weight: FontWeight.w500)),
        Text(subtitle, style: AppTheme.poppins(size: 7, color: AppTheme.muted)),
      ],
    );
  }

  Widget _buildVariantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _variantLabel,
              style: AppTheme.poppins(size: 12, weight: FontWeight.w600),
            ),
            Text(
              'Selecciona una opción',
              style: AppTheme.poppins(size: 8, color: AppTheme.muted),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final v in _variants) ...[
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _variant = v),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: _variant == v
                          ? const Color(0xFFFBF5F7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: _variant == v ? AppTheme.wine : AppTheme.line,
                        width: _variant == v ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      v,
                      style: AppTheme.poppins(
                        size: 9,
                        weight: _variant == v
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _variant == v ? AppTheme.wine : AppTheme.plum,
                      ),
                    ),
                  ),
                ),
              ),
              if (v != _variants.last) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildExpandable(String title, String body) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.line),
          bottom: BorderSide(color: AppTheme.line),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 1),
          childrenPadding: const EdgeInsets.only(bottom: 10),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          iconColor: AppTheme.plum,
          collapsedIconColor: AppTheme.plum,
          title: Text(
            title,
            style: AppTheme.poppins(size: 11, weight: FontWeight.w600),
          ),
          children: [
            Text(
              body,
              style: AppTheme.poppins(
                size: 10,
                color: AppTheme.muted,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizeCallout() {
    return GestureDetector(
      onTap: _openCustomize,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFF4E6EC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: AppTheme.wine,
                borderRadius: BorderRadius.circular(13),
              ),
              alignment: Alignment.center,
              child: const AppIcon('sparkle', size: 20, color: Colors.white),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hazlo aún más especial',
                    style: AppTheme.poppins(
                      size: 10,
                      weight: FontWeight.w600,
                      color: AppTheme.wine,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Personaliza el empaque y añade una dedicatoria',
                    style: AppTheme.poppins(
                      size: 8,
                      color: const Color(0xFF866779),
                    ),
                  ),
                ],
              ),
            ),
            const AppIcon('chevron', size: 20, color: AppTheme.wine),
          ],
        ),
      ),
    );
  }
}

/// Botón circular flotante sobre la imagen del detalle.
class _FloatingButton extends StatelessWidget {
  const _FloatingButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: AppIcon(icon, size: 22, color: color),
      ),
    );
  }
}

/// Aviso flotante mostrado al agregar un producto al carrito.
class _Toast extends StatelessWidget {
  const _Toast({required this.onViewCart});

  final VoidCallback onViewCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3F3037),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF6D985E),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const AppIcon('check', size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Producto agregado al carrito',
              style: AppTheme.poppins(size: 10, color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: onViewCart,
            child: Text(
              'Ver carrito',
              style: AppTheme.poppins(
                size: 10,
                weight: FontWeight.w600,
                color: const Color(0xFFEDC5D6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
