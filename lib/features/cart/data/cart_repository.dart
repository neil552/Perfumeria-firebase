import 'package:flutter/foundation.dart';

import '../../catalog/data/product_model.dart';

/// Elemento del carrito de compras.
///
/// Equivale al tipo `CartItem` del proyecto React original: un producto más
/// la cantidad y los datos de personalización (empaque, tarjeta, dedicatoria).
class CartItem {
  CartItem({
    required this.product,
    this.quantity = 1,
    this.wrapping,
    this.card,
    this.dedication,
    this.extra = 0,
    this.variant,
  });

  final Product product;
  int quantity;
  final String? wrapping;
  final String? card;
  final String? dedication;
  final double extra;
  final String? variant;

  /// Precio unitario incluyendo el costo de personalización.
  double get unitPrice => product.price + extra;

  /// Total de la línea (precio unitario por cantidad).
  double get lineTotal => unitPrice * quantity;

  bool get isCustomized => wrapping != null;
}

/// Repositorio del carrito de compras (estado compartido en memoria).
///
/// Sustituye el estado `cart` del componente `App` de React, manteniendo
/// la misma lógica de agregar, incrementar, quitar y calcular totales.
class CartRepository {
  CartRepository._();

  /// Instancia única compartida por toda la aplicación.
  static final CartRepository instance = CartRepository._();

  /// Lista reactiva de elementos en el carrito.
  final ValueNotifier<List<CartItem>> items =
      ValueNotifier<List<CartItem>>(<CartItem>[]);

  /// Cantidad total de unidades.
  int get count => items.value.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.value.isEmpty;

  /// Suma de precios de producto (sin personalización).
  double get subtotal => items.value.fold(
        0.0,
        (sum, item) => sum + item.product.price * item.quantity,
      );

  /// Suma de los costos de personalización.
  double get extras => items.value.fold(
        0.0,
        (sum, item) => sum + item.extra * item.quantity,
      );

  /// Total del carrito (subtotal + personalización).
  double get total => subtotal + extras;

  /// Agrega un producto; si ya existe incrementa su cantidad.
  void add(Product product, {String? variant}) {
    final list = List<CartItem>.from(items.value);
    final index = list.indexWhere(
      (item) => item.product.id == product.id && item.variant == variant,
    );
    if (index >= 0) {
      list[index].quantity += 1;
    } else {
      list.add(CartItem(product: product, variant: variant));
    }
    items.value = list;
  }

  /// Agrega (o reemplaza) un producto personalizado.
  void addCustom(CartItem item) {
    final list = items.value
        .where((x) => x.product.id != item.product.id)
        .toList();
    list.add(item);
    items.value = list;
  }

  /// Modifica la cantidad de un elemento (mínimo 1).
  void changeQuantity(int productId, int delta, {String? variant}) {
    final list = List<CartItem>.from(items.value);
    for (final item in list) {
      if (item.product.id == productId && item.variant == variant) {
        final next = item.quantity + delta;
        item.quantity = next < 1 ? 1 : next;
      }
    }
    items.value = list;
  }

  /// Elimina un elemento del carrito.
  void remove(int productId, {String? variant}) {
    items.value = items.value
        .where(
          (item) => item.product.id != productId || item.variant != variant,
        )
        .toList();
  }

  /// Vacía el carrito.
  void clear() {
    items.value = <CartItem>[];
  }
}
