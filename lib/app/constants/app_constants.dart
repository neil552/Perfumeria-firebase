/// Constantes globales de la aplicación "Regalos & Esencias".
class AppConstants {
  AppConstants._();

  /// Nombre comercial de la marca.
  static const String appName = 'Regalos & Esencias';

  /// Primer bloque del logotipo.
  static const String brandPrimary = 'Regalos';

  /// Separador decorativo del logotipo.
  static const String brandDivider = '&';

  /// Segundo bloque del logotipo.
  static const String brandSecondary = 'Esencias';

  /// Texto de versión mostrado en la pantalla de perfil.
  static const String versionText =
      'Regalos & Esencias · Versión académica 1.0';

  /// Costo del servicio de delivery (S/).
  static const double deliveryFee = 8.0;

  /// Ancho máximo del contenido para mantener la proporción del diseño Figma.
  static const double maxContentWidth = 430.0;
}

/// Recursos gráficos originales del proyecto de referencia (React/Figma).
///
/// Se reutilizan las mismas rutas del diseño original para conservar la
/// fidelidad visual sin reemplazar imágenes por recursos genéricos.
class AppImages {
  AppImages._();

  static const String hero =
      'https://images.unsplash.com/photo-1556228149-0b37a8638663?auto=format&fit=crop&w=1200&q=85';
  static const String perfume =
      'https://images.unsplash.com/photo-1630573133526-8d090e0269af?auto=format&fit=crop&w=900&q=85';
  static const String perfume2 =
      'https://images.unsplash.com/photo-1708486235073-14879ff14c4c?auto=format&fit=crop&w=900&q=85';
  static const String perfume3 =
      'https://images.unsplash.com/photo-1591375275686-e9b036b15f95?auto=format&fit=crop&w=900&q=85';
  static const String flowers =
      'https://images.unsplash.com/photo-1579532649461-b2c6edf65546?auto=format&fit=crop&w=900&q=85';
  static const String bear =
      'https://images.unsplash.com/photo-1708523955985-463c307c00b5?auto=format&fit=crop&w=900&q=85';
  static const String gift =
      'https://images.unsplash.com/photo-1787074625726-49e7b3e16683?auto=format&fit=crop&w=900&q=85';
  static const String bouquet =
      'https://images.unsplash.com/photo-1790041258525-1a4604998b77?auto=format&fit=crop&w=900&q=85';
}
