import 'package:flutter/foundation.dart';

/// Mantiene los productos favoritos durante la sesión actual de la app.
///
/// El notifier permite actualizar la lista y los indicadores de perfil al
/// mismo tiempo; por ahora, los favoritos no se persisten al cerrar la app.
class FavoritesRepository {
  FavoritesRepository._();

  /// IDs seleccionados; se reemplaza el conjunto para notificar cada cambio.
  static final ValueNotifier<Set<int>> productIds = ValueNotifier<Set<int>>(
    <int>{},
  );

  /// Indica si el producto ya está guardado.
  static bool contains(int productId) => productIds.value.contains(productId);

  /// Agrega el ID si no existe o lo quita si ya estaba guardado.
  static void toggle(int productId) {
    final next = Set<int>.from(productIds.value);
    if (!next.add(productId)) {
      next.remove(productId);
    }
    productIds.value = next;
  }
}
