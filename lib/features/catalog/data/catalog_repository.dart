import '../../../app/constants/app_constants.dart';
import 'product_model.dart';

/// Repositorio del catálogo de productos (datos en memoria, sin backend).
///
/// Reutiliza exactamente la lista `products` del proyecto React original.
class CatalogRepository {
  CatalogRepository._();

  static const List<Product> products = [
    Product(
      id: 1,
      name: 'Box Esencia Rosé',
      category: 'Cajas sorpresa',
      price: 89.9,
      oldPrice: 109.9,
      image: AppImages.gift,
      customizable: true,
      badge: '-18%',
    ),
    Product(
      id: 2,
      name: 'Bloom Eau de Parfum',
      category: 'Perfumes',
      price: 129.9,
      image: AppImages.perfume,
      badge: 'Nuevo',
    ),
    Product(
      id: 3,
      name: 'Abrazo & Rosa',
      category: 'Peluches',
      price: 74.9,
      image: AppImages.bear,
      customizable: true,
    ),
    Product(
      id: 4,
      name: 'Jardín de Gratitud',
      category: 'Flores',
      price: 64.9,
      image: AppImages.flowers,
      customizable: true,
    ),
    Product(
      id: 5,
      name: 'Lumière Femme',
      category: 'Fragancias mujer',
      price: 149.9,
      oldPrice: 179.9,
      image: AppImages.perfume2,
      badge: '-17%',
    ),
    Product(
      id: 6,
      name: 'Dúo Signature',
      category: 'Sets de fragancias',
      price: 169.9,
      image: AppImages.perfume3,
    ),
  ];

  /// Productos destacados mostrados en la pantalla de inicio (primeros 4).
  static List<Product> get featured => products.take(4).toList();

  /// Productos con descuento (usados en la pantalla de promociones).
  static List<Product> get discounted =>
      products.where((p) => p.oldPrice != null).toList();
}
