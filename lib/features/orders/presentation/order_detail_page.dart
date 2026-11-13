import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../app/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../data/orders_repository.dart';

/// Pantalla de detalle y seguimiento de un pedido.
///
/// Recibe el [OrderModel] mediante los argumentos de la ruta nombrada.
class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  static const List<List<Object>> _states = [
    ['Pedido recibido', 'Hoy, 9:42 a. m.', true],
    ['En preparación', 'Estamos cuidando cada detalle', true],
    ['Listo para recoger', 'Te avisaremos apenas esté listo', false],
    ['Entregado', 'Disfruta tu regalo', false],
  ];

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments;
    if (order is! OrderModel) {
      return Scaffold(
        body: Center(
          child: Text(
            'No se encontró el pedido.',
            style: AppTheme.poppins(size: 13, color: AppTheme.plum),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppHeader(
                title: 'Detalle del pedido',
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 4),
              _buildStatusHero(order),
              const SizedBox(height: 13),
              _buildTimeline(order),
              const SizedBox(height: 13),
              _buildSummary(order),
              const SizedBox(height: 13),
              _buildAddress(order),
              const SizedBox(height: 13),
              _buildSupport(context, order.code),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHero(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF4B333F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -55,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x1FFFFFFF)),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.code,
                style: AppTheme.poppins(
                  size: 8,
                  color: const Color(0xFFDBBDCA),
                ),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Tu pedido está\n'),
                    TextSpan(
                      text: order.status.toLowerCase(),
                      style: AppTheme.playfair(
                        size: 25,
                        weight: FontWeight.w500,
                        color: const Color(0xFFE8BDCE),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                style: AppTheme.playfair(
                  size: 25,
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Entrega estimada: '
                '${order.deliveryDate.isEmpty ? order.date : order.deliveryDate}',
                style: AppTheme.poppins(
                  size: 8,
                  color: const Color(0xFFDFD2D7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (var index = 0; index < _states.length; index++)
            _timelineRow(index, order),
        ],
      ),
    );
  }

  Widget _timelineRow(int index, OrderModel order) {
    final state = _states[index];
    final title = state[0] as String;
    final text = index == 0 ? order.date : state[1] as String;
    final done = order.active ? state[2] as bool : true;
    final isLast = index == _states.length - 1;

    return SizedBox(
      height: isLast ? null : 59,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25,
            child: Column(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: done ? AppTheme.wine : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: done ? AppTheme.wine : const Color(0xFFD8C9C6),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: done
                      ? const AppIcon('check', size: 14, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: AppTheme.poppins(
                            size: 8,
                            color: const Color(0xFFAA999F),
                          ),
                        ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: done ? AppTheme.wine : const Color(0xFFE1D5D2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.poppins(size: 9, weight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    text,
                    style: AppTheme.poppins(size: 7, color: AppTheme.muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Resumen del pedido',
            style: AppTheme.poppins(size: 14, weight: FontWeight.w600),
          ),
          const SizedBox(height: 13),
          if (order.items.isEmpty)
            _buildOrderLine(
              image: order.image,
              name: 'Detalle del pedido',
              details: 'Información de ejemplo',
              total: order.total,
            )
          else
            for (final item in order.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildOrderLine(
                  image: item.image,
                  name: item.productName,
                  details: [
                    'Cantidad: ${item.quantity}',
                    item.description,
                  ].where((value) => value.isNotEmpty).join(' · '),
                  total: item.total,
                ),
              ),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.only(top: 11),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.line)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.deliveryMode,
                  style: AppTheme.poppins(size: 9, color: AppTheme.muted),
                ),
                Text(
                  soles(
                    order.deliveryMode == 'Delivery'
                        ? AppConstants.deliveryFee
                        : 0,
                  ),
                  style: AppTheme.poppins(size: 9, weight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 11),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.line)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTheme.poppins(size: 13, weight: FontWeight.w600),
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
          ),
        ],
      ),
    );
  }

  Widget _buildOrderLine({
    required String image,
    required String name,
    required String details,
    required double total,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SizedBox(
            width: 44,
            height: 44,
            child: AppImage(url: image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTheme.poppins(size: 8, weight: FontWeight.w600),
              ),
              if (details.isNotEmpty)
                Text(
                  details,
                  style: AppTheme.poppins(size: 6, color: AppTheme.muted),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          soles(total),
          style: AppTheme.poppins(size: 8, weight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildAddress(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información de entrega',
            style: AppTheme.poppins(size: 14, weight: FontWeight.w600),
          ),
          const SizedBox(height: 13),
          _addressRow(
            'pin',
            order.address.isEmpty ? 'Av. Los Rosales 245' : order.address,
            order.reference.isEmpty
                ? 'Miraflores · Frente al parque'
                : order.reference,
          ),
          const SizedBox(height: 12),
          _addressRow(
            'phone',
            order.customerName.isEmpty ? 'Valeria Mendoza' : order.customerName,
            order.phone.isEmpty ? '+51 987 654 321' : order.phone,
          ),
        ],
      ),
    );
  }

  Widget _addressRow(String icon, String title, String subtitle) {
    return Row(
      children: [
        AppIcon(icon, size: 20, color: AppTheme.wine),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.poppins(
                size: 9,
                weight: FontWeight.w600,
                color: AppTheme.plum,
              ),
            ),
            Text(
              subtitle,
              style: AppTheme.poppins(size: 7, color: AppTheme.muted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSupport(BuildContext context, String orderCode) {
    return GestureDetector(
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ayuda con tu pedido'),
          content: Text(
            'Tu código de pedido es $orderCode. El canal de atención de la '
            'tienda aún no está configurado en esta versión de demostración.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.pink),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIcon('phone', size: 19, color: AppTheme.wine),
            const SizedBox(width: 7),
            Text(
              '¿Necesitas ayuda con tu pedido?',
              style: AppTheme.poppins(size: 9, color: AppTheme.wine),
            ),
          ],
        ),
      ),
    );
  }
}
