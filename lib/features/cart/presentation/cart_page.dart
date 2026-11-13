import 'package:flutter/material.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/action_footer.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/custom_button.dart';
import '../data/cart_repository.dart';

/// Pantalla del carrito de compras.
///
/// Equivale al componente `Cart` del proyecto React original.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CartRepository.instance;
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: repo.items,
      builder: (context, items, _) {
        return Scaffold(
          bottomNavigationBar: items.isEmpty
              ? null
              : ActionFooter(
                  note:
                      'Compra demostrativa · No se solicitarán datos bancarios',
                  child: PrimaryButton(
                    label: 'Continuar con la compra',
                    trailing: const AppIcon('chevron', size: 18),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.checkout),
                  ),
                ),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppHeader(
                    title: 'Mi carrito',
                    onBack: () => Navigator.pop(context),
                  ),
                  if (items.isEmpty)
                    _buildEmpty(context)
                  else ...[
                    const SizedBox(height: 5),
                    Text(
                      '${repo.count} productos en tu selección',
                      style: AppTheme.poppins(size: 10, color: AppTheme.muted),
                    ),
                    const SizedBox(height: 15),
                    for (final item in items) ...[
                      _CartItemCard(item: item),
                      const SizedBox(height: 11),
                    ],
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.catalog,
                        ),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '+ Agregar otro detalle',
                            style: AppTheme.poppins(
                              size: 10,
                              weight: FontWeight.w600,
                              color: AppTheme.wine,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _OrderSummary(repo: repo),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 95, horizontal: 25),
      child: Column(
        children: [
          Transform.rotate(
            angle: -4 * 3.1415926 / 180,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFEEDFE5),
                borderRadius: BorderRadius.circular(35),
              ),
              alignment: Alignment.center,
              child: const AppIcon('bag', size: 42, color: AppTheme.wine),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tu carrito espera una sorpresa',
            textAlign: TextAlign.center,
            style: AppTheme.playfair(size: 26, weight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            'Descubre detalles creados para emocionar y encuentra el indicado.',
            textAlign: TextAlign.center,
            style: AppTheme.poppins(
              size: 11,
              color: AppTheme.muted,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Explorar productos',
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.catalog),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de un producto dentro del carrito.
class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final repo = CartRepository.instance;
    final product = item.product;
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: AppTheme.plum.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 94,
              height: 118,
              child: AppImage(url: product.image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category,
                  style: AppTheme.poppins(size: 7, color: AppTheme.muted),
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  style: AppTheme.poppins(size: 11, weight: FontWeight.w500),
                ),
                if (item.variant != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    '${item.product.isFragrance ? 'Presentación' : 'Tamaño'}: '
                    '${item.variant}',
                    style: AppTheme.poppins(size: 7, color: AppTheme.muted),
                  ),
                ],
                const SizedBox(height: 5),
                Text(
                  soles(item.unitPrice),
                  style: AppTheme.poppins(
                    size: 11,
                    weight: FontWeight.w600,
                    color: AppTheme.wine,
                  ),
                ),
                if (item.wrapping != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: AppIcon(
                          'sparkle',
                          size: 15,
                          color: AppTheme.wine,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personalizado',
                              style: AppTheme.poppins(
                                size: 7,
                                weight: FontWeight.w600,
                                color: AppTheme.wine,
                              ),
                            ),
                            Text(
                              '${item.wrapping} · Tarjeta ${item.card}',
                              style: AppTheme.poppins(
                                size: 6,
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                if (item.dedication != null && item.dedication!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.only(left: 6),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: AppTheme.pink, width: 2),
                      ),
                    ),
                    child: Text(
                      '“${item.dedication}”',
                      style: AppTheme.playfair(
                        size: 7,
                        weight: FontWeight.w500,
                        color: const Color(0xFF8A757D),
                        height: 1.3,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.line),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        children: [
                          _QtyButton(
                            label: '−',
                            onTap: () => repo.changeQuantity(
                              product.id,
                              -1,
                              variant: item.variant,
                            ),
                          ),
                          SizedBox(
                            width: 22,
                            child: Text(
                              '${item.quantity}',
                              textAlign: TextAlign.center,
                              style: AppTheme.poppins(size: 9),
                            ),
                          ),
                          _QtyButton(
                            label: '+',
                            onTap: () => repo.changeQuantity(
                              product.id,
                              1,
                              variant: item.variant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          repo.remove(product.id, variant: item.variant),
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: AppIcon(
                          'trash',
                          size: 18,
                          color: Color(0xFFB28595),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Controla un cambio de una unidad en la cantidad de una línea del carrito.
class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 28,
        height: 26,
        child: Center(
          child: Text(
            label,
            style: AppTheme.poppins(size: 13, color: AppTheme.plum),
          ),
        ),
      ),
    );
  }
}

/// Resumen del pedido con subtotal, personalización y total.
class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.repo});

  final CartRepository repo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen del pedido',
            style: AppTheme.poppins(size: 14, weight: FontWeight.w600),
          ),
          const SizedBox(height: 13),
          _line('Subtotal', soles(repo.subtotal)),
          if (repo.extras > 0) _line('Personalización', soles(repo.extras)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entrega',
                  style: AppTheme.poppins(size: 9, color: AppTheme.muted),
                ),
                Text(
                  'Se calcula después',
                  style: AppTheme.poppins(size: 9, color: AppTheme.gold),
                ),
              ],
            ),
          ),
          const Divider(height: 12, color: AppTheme.line),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTheme.poppins(size: 13, weight: FontWeight.w600),
              ),
              Text(
                soles(repo.total),
                style: AppTheme.poppins(
                  size: 16,
                  weight: FontWeight.w600,
                  color: AppTheme.wine,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.poppins(size: 9, color: AppTheme.muted)),
          Text(
            value,
            style: AppTheme.poppins(size: 9, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
