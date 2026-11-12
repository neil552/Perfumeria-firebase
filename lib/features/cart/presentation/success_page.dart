import 'package:flutter/material.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/custom_button.dart';
import '../../orders/data/orders_repository.dart';

/// Pantalla de confirmación de pedido.
///
/// Equivale al componente `Success` del proyecto React original.
class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments;
    if (order is! OrderModel) {
      return Scaffold(
        body: Center(
          child: Text(
            'No hay un pedido para mostrar.',
            style: AppTheme.poppins(size: 13, color: AppTheme.plum),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7EDE9), Color(0xFFFFFAF7)],
          ),
        ),
        child: Stack(
          children: [
            const _Decoration(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 30),
                child: Column(
                  children: [
                    _buildIcon(),
                    const SizedBox(height: 20),
                    Text('PEDIDO CONFIRMADO', style: AppTheme.eyebrow()),
                    const SizedBox(height: 7),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '¡Tu pedido ha sido\n',
                            style: AppTheme.playfair(
                              size: 32,
                              weight: FontWeight.w600,
                              height: 1.15,
                            ),
                          ),
                          TextSpan(
                            text: 'registrado!',
                            style: AppTheme.playfair(
                              size: 32,
                              weight: FontWeight.w500,
                              color: AppTheme.wine,
                              height: 1.15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Estamos preparando cada detalle con mucho cariño.',
                      textAlign: TextAlign.center,
                      style: AppTheme.poppins(size: 11, color: AppTheme.muted),
                    ),
                    const SizedBox(height: 24),
                    _buildOrderCode(order.code),
                    const SizedBox(height: 14),
                    _buildSummary(order),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: 'Ver mis pedidos',
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.orders,
                      ),
                    ),
                    const SizedBox(height: 9),
                    SecondaryButton(
                      label: 'Volver al inicio',
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.home,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 84,
      height: 84,
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: AppTheme.wine,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFEAD4DE), width: 10),
        boxShadow: [
          BoxShadow(
            color: AppTheme.wine.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const AppIcon('check', size: 38, color: Colors.white),
    );
  }

  Widget _buildOrderCode(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4B4C1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Text(
            'CÓDIGO DE PEDIDO',
            style: AppTheme.poppins(
              size: 7,
              color: AppTheme.muted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            code,
            style: AppTheme.poppins(
              size: 18,
              weight: FontWeight.w600,
              color: AppTheme.wine,
              letterSpacing: 1.5,
            ),
          ),
          Text(
            'Guárdalo para consultar tu pedido',
            style: AppTheme.poppins(size: 7, color: AppTheme.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          _summaryRow('calendar', 'Fecha estimada', order.deliveryDate),
          const SizedBox(height: 9),
          _summaryRow('clock', 'Horario', order.deliveryTime),
          const Divider(height: 24, color: AppTheme.line),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order.itemCount} productos',
                      style: AppTheme.poppins(size: 7, color: AppTheme.muted),
                    ),
                    Text(
                      'Total del pedido',
                      style: AppTheme.poppins(
                        size: 9,
                        weight: FontWeight.w600,
                        color: AppTheme.plum,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                soles(order.total),
                style: AppTheme.poppins(
                  size: 15,
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

  Widget _summaryRow(String icon, String label, String value) {
    return Row(
      children: [
        AppIcon(icon, size: 20, color: AppTheme.wine),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTheme.poppins(size: 7, color: AppTheme.muted),
            ),
            Text(
              value,
              style: AppTheme.poppins(
                size: 9,
                weight: FontWeight.w600,
                color: AppTheme.plum,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Círculos decorativos del fondo de la pantalla de éxito.
class _Decoration extends StatelessWidget {
  const _Decoration();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(right: -100, top: -80, child: _Ring(size: 180)),
        Positioned(left: -45, top: 180, child: _Ring(size: 90)),
        Positioned(
          right: 40,
          top: 190,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.gold,
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 8, height: 8),
          ),
        ),
      ],
    );
  }
}

/// Dibuja un aro decorativo translúcido de la pantalla de confirmación.
class _Ring extends StatelessWidget {
  const _Ring({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE6CDD7)),
      ),
    );
  }
}
