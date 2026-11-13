import 'package:flutter/material.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../data/orders_repository.dart';

/// Pantalla del historial de pedidos.
///
/// Equivale al componente `Orders` del proyecto React original.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

/// Escucha los cambios del historial y actualiza la lista de pedidos.
class _OrdersPageState extends State<OrdersPage> {
  String _tab = 'En curso';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        current: AppRoutes.orders,
        onNavigate: (route) => Navigator.pushReplacementNamed(context, route),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(title: 'Mis pedidos'),
              const SizedBox(height: 11),
              Text(
                'Acompaña cada detalle',
                style: AppTheme.poppins(
                  size: 9,
                  weight: FontWeight.w600,
                  color: AppTheme.wine,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Tu historial de emociones',
                style: AppTheme.playfair(size: 27, weight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<List<OrderModel>>(
                valueListenable: OrdersRepository.items,
                builder: (context, orders, _) {
                  final activeCount = orders
                      .where((order) => order.active)
                      .length;
                  final visibleOrders = orders
                      .where(
                        (order) =>
                            _tab == 'En curso' ? order.active : !order.active,
                      )
                      .toList();
                  return Column(
                    children: [
                      _buildTabs(activeCount: activeCount),
                      const SizedBox(height: 16),
                      if (visibleOrders.isEmpty)
                        _buildEmptyState()
                      else
                        for (final order in visibleOrders) ...[
                          _OrderCard(
                            order: order,
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.orderDetail,
                              arguments: order,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs({required int activeCount}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEE3E3),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Expanded(
            child: _tabButton('En curso', badge: activeCount.toString()),
          ),
          Expanded(child: _tabButton('Completados')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 18),
      child: Text(
        _tab == 'En curso'
            ? 'No tienes pedidos en curso.'
            : 'Aún no tienes pedidos completados.',
        textAlign: TextAlign.center,
        style: AppTheme.poppins(size: 11, color: AppTheme.muted),
      ),
    );
  }

  Widget _tabButton(String label, {String? badge}) {
    final active = _tab == label;
    return GestureDetector(
      onTap: () => setState(() => _tab = label),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTheme.poppins(
                size: 10,
                weight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppTheme.wine : AppTheme.muted,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 4),
              Container(
                width: 17,
                height: 17,
                decoration: const BoxDecoration(
                  color: AppTheme.wine,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  badge,
                  style: AppTheme.poppins(size: 7, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de un pedido del historial.
class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final OrderModel order;
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
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 78,
                height: 87,
                child: AppImage(url: order.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.code,
                    style: AppTheme.poppins(size: 7, color: AppTheme.muted),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    order.date,
                    style: AppTheme.poppins(size: 10, weight: FontWeight.w500),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'S/ ${order.total.toStringAsFixed(2)}',
                    style: AppTheme.poppins(size: 10),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order.active
                          ? const Color(0xFFF3E4CE)
                          : const Color(0xFFE3EDDF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: AppTheme.poppins(
                        size: 7,
                        color: order.active
                            ? const Color(0xFF8E692F)
                            : const Color(0xFF56734A),
                      ),
                    ),
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
