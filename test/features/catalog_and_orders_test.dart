// Comprueba reglas de clasificación, favoritos y serialización de pedidos.
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

  // Comprueba que se conserva la información necesaria al reconstruir el pedido.
  test('order data can be serialized and restored', () {
    const order = OrderModel(
      code: 'RE-TEST-001',
      date: '12 Nov 2026',
      total: 25,
      status: 'En preparación',
      image: '',
      active: true,
      items: [
        OrderItemModel(
          productName: 'Set de prueba',
          image: 'https://example.com/product.png',
          quantity: 2,
          unitPrice: 25,
          wrapping: 'Caja premium',
          dedication: 'Feliz día',
        ),
      ],
      deliveryMode: 'Delivery',
      deliveryDate: 'Vie. 13 Nov',
      deliveryTime: '10:00 - 13:00',
      customerName: 'Cliente de prueba',
      phone: '999111222',
      address: 'Calle de prueba 123',
      reference: 'Puerta azul',
    );

    final restored = OrderModel.fromMap('firestore-order-id', order.toMap());

    expect(restored.id, 'firestore-order-id');
    expect(restored.code, order.code);
    expect(restored.total, order.total);
    expect(restored.itemCount, 2);
    expect(
      restored.items.single.description,
      'Caja premium · Dedicatoria incluida',
    );
    expect(restored.deliveryDate, order.deliveryDate);
    expect(restored.address, order.address);
  });
}
