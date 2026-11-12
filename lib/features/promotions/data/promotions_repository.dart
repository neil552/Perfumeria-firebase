/// Repositorio de promociones y cupones (datos en memoria, sin backend).
///
/// Reutiliza el cupón `PRIMERDETALLE` del proyecto React original.
class PromotionsRepository {
  PromotionsRepository._();

  static const String couponLabel = 'CUPÓN DE BIENVENIDA';
  static const String couponCode = 'PRIMERDETALLE';
  static const String couponDescription =
      '10% de descuento en tu primera compra';

  static const String heroEyebrow = 'SOLO ESTA SEMANA';
  static const String heroTitle = 'Momentos que merecen celebrarse';
  static const String heroSubtitle =
      'Hasta 20% de descuento en detalles seleccionados.';
}
