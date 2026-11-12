import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clase centralizada para gestionar el diseño visual y la paleta de colores
/// oficial de la aplicación "Regalos & Esencias".
class AppTheme {
  // ==========================================
  // PALETA ORIGINAL (se conserva por compatibilidad)
  // ==========================================

  /// Color principal: Rosa Pasión (Acento vibrante y llamadas a la acción)
  static const Color rosaPasion = Color(0xFFAD1457);

  /// Color secundario/aclarado: Rosa Suave (Fondos sutiles o tarjetas)
  static const Color rosaSuave = Color(0xFFF8BBD0);

  /// Color de fondo general: Crema (Fondo cálido y elegante para la app)
  static const Color crema = Color(0xFFFFF8E1);

  /// Color complementario: Lavanda (Secciones secundarias o detalles)
  static const Color lavanda = Color(0xFFD1C4E9);

  /// Color de contraste: Morado Elegante (Títulos, textos o elementos formales)
  static const Color moradoElegante = Color(0xFF4A148C);

  // ==========================================
  // PALETA DEL DISEÑO (migrada desde referencia_react/src/index.css)
  // ==========================================

  /// Vino: color principal de marca y de las llamadas a la acción.
  static const Color wine = Color(0xFF8E4569);

  /// Vino oscuro: estado activo de los botones principales.
  static const Color wineDark = Color(0xFF713451);

  /// Rosa: bordes suaves y acentos secundarios.
  static const Color pink = Color(0xFFD9A6B9);

  /// Crema: fondo general de las pantallas.
  static const Color cream = Color(0xFFF8F2EC);

  /// Dorado: acento del logotipo y de los cupones.
  static const Color gold = Color(0xFFD6B77B);

  /// Ciruela: color del texto principal.
  static const Color plum = Color(0xFF493740);

  /// Gris rosado: textos secundarios y placeholders.
  static const Color muted = Color(0xFF8D7C83);

  /// Línea: bordes y separadores.
  static const Color line = Color(0xFFEADED8);

  /// Fondo exterior (detrás de las tarjetas blancas).
  static const Color pageBackground = Color(0xFFE8DED8);

  // ==========================================
  // HELPERS DE TIPOGRAFÍA
  // ==========================================

  /// Tipografía de títulos (Playfair Display).
  static TextStyle playfair({
    double size = 16,
    FontWeight weight = FontWeight.w600,
    Color color = plum,
    double? height,
    FontStyle fontStyle = FontStyle.normal,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
    );
  }

  /// Tipografía de cuerpo y componentes (Poppins).
  static TextStyle poppins({
    double size = 12,
    FontWeight weight = FontWeight.w400,
    Color color = plum,
    double? height,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Estilo del texto "eyebrow" (etiquetas superiores en mayúsculas).
  static TextStyle eyebrow({Color color = wine, double letterSpacing = 1.6}) {
    return poppins(
      size: 10,
      weight: FontWeight.w600,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // ==========================================
  // CONFIGURACIÓN DEL TEMA CLARO
  // ==========================================

  /// Construye el tema global Material 3 a partir de los colores de marca.
  ///
  /// Las pantallas deben consumir estos tokens y helpers en lugar de definir
  /// colores o estilos tipográficos propios.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: wine,
        primary: wine,
        secondary: plum,
        surface: cream,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: plum,
        elevation: 0,
        centerTitle: true,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: wine,
        selectionHandleColor: wine,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: wine,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
