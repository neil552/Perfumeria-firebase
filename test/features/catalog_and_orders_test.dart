// Comprueba reglas de clasificación, favoritos y ordenación del historial.
//
// Los casos ejercitan repositorios en memoria, por lo que no requieren una
// conexión a Firebase ni un dispositivo de prueba.
import 'package:flutter_test/flutter_test.dart';
import 'package:perfumeria/features/catalog/data/favorites_repository.dart';
import 'package:perfumeria/features/catalog/data/product_model.dart';
import 'package:perfumeria/features/orders/data/orders_repository.dart';

void main() {
  // Comprueba la clasificación de categorías sin depender de datos de la UI.
  test('classifies lowercase fragrance categories correctly', () {
    const product = Product(
      id: 100,
      name: 'Set de prueba',
      category: 'Sets de fragancias',
      price: 100,
      image: '',
    );

    expect(product.isFragrance, isTrue);
  });

  // Verifica el ciclo de activación y desactivación de un favorito.
  test('favorites can be added and removed', () {
    const productId = 100;
    expect(FavoritesRepository.contains(productId), isFalse);

    FavoritesRepository.toggle(productId);
    expect(FavoritesRepository.contains(productId), isTrue);

    FavoritesRepository.toggle(productId);
    expect(FavoritesRepository.contains(productId), isFalse);
  });

  // Restaura la lista original para aislar esta prueba del estado global.
  test('new orders appear first in the order history', () {
    final previousOrders = OrdersRepository.orders;
    addTearDown(() => OrdersRepository.items.value = previousOrders);
    const order = OrderModel(
      code: 'RE-TEST-001',
      date: '12 Nov 2026',
      total: 25,
      status: 'En preparación',
      image: '',
      active: true,
    );

    OrdersRepository.add(order);

    expect(OrdersRepository.orders.first, same(order));
  });
}
