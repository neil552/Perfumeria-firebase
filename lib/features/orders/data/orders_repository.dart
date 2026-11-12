import 'package:flutter/foundation.dart';

import '../../../app/constants/app_constants.dart';

/// Copia de una línea del carrito guardada en el resumen de un pedido.
class OrderItemModel {
  const OrderItemModel({
    required this.productName,
    required this.image,
    required this.quantity,
    required this.unitPrice,
    this.wrapping,
    this.card,
    this.dedication,
    this.variant,
  });

  final String productName;
  final String image;
  final int quantity;
  final double unitPrice;
  final String? wrapping;
  final String? card;
  final String? dedication;
  final String? variant;

  double get total => unitPrice * quantity;

  String get description => [
    wrapping,
    card,
    variant,
    if (dedication != null && dedication!.isNotEmpty) 'Dedicatoria incluida',
  ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');
}

/// Modelo de un pedido del historial.
class OrderModel {
  const OrderModel({
    required this.code,
    required this.date,
    required this.total,
    required this.status,
    required this.image,
    this.active = false,
    this.items = const [],
    this.deliveryMode = 'Delivery',
    this.deliveryDate = '',
    this.deliveryTime = '',
    this.customerName = '',
    this.phone = '',
    this.address = '',
    this.reference = '',
  });

  final String code;
  final String date;
  final double total;
  final String status;
  final String image;
  final bool active;
  final List<OrderItemModel> items;
  final String deliveryMode;
  final String deliveryDate;
  final String deliveryTime;
  final String customerName;
  final String phone;
  final String address;
  final String reference;

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);
}

/// Repositorio en memoria para el historial de pedidos de demostración.
///
/// La lista incluye registros de ejemplo y los pedidos creados durante la
/// sesión; se reinicia al cerrar la aplicación.
class OrdersRepository {
  OrdersRepository._();

  static final ValueNotifier<List<OrderModel>> items =
      ValueNotifier<List<OrderModel>>([
        OrderModel(
          code: 'RE-250518-042',
          date: '18 May 2025',
          total: 109.90,
          status: 'En preparación',
          image: AppImages.gift,
          active: true,
        ),
        OrderModel(
          code: 'RE-240312-018',
          date: '12 Mar 2025',
          total: 149.90,
          status: 'Entregado',
          image: AppImages.perfume2,
        ),
        OrderModel(
          code: 'RE-241220-006',
          date: '20 Dic 2024',
          total: 74.90,
          status: 'Entregado',
          image: AppImages.bear,
        ),
      ]);

  static List<OrderModel> get orders => items.value;

  /// Inserta el pedido nuevo al inicio para mostrarlo primero en el historial.
  static void add(OrderModel order) {
    items.value = [order, ...items.value];
  }
}
