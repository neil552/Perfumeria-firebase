/// Modelo de un producto del catálogo.
///
/// Equivale al tipo `Product` definido en `referencia_react/src/App.tsx`.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.image,
    this.customizable = false,
    this.badge,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String image;
  final bool customizable;
  final String? badge;

  /// Indica si el producto pertenece al rubro de perfumería (para
  /// determinar la presentación/tamaño en la pantalla de detalle).
  bool get isFragrance =>
      category.toLowerCase().contains('perfume') ||
      category.toLowerCase().contains('fragancia');
}
