import 'package:flutter/material.dart';

// Importaciones de pantallas
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/welcome_page.dart';
import '../../features/cart/presentation/cart_page.dart';
import '../../features/cart/presentation/checkout_page.dart';
import '../../features/cart/presentation/success_page.dart';
import '../../features/catalog/presentation/catalog_page.dart';
import '../../features/catalog/presentation/favorites_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/orders/presentation/order_detail_page.dart';
import '../../features/orders/presentation/orders_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/profile/presentation/personal_data_page.dart';
import '../../features/promotions/presentation/promotions_page.dart';

/// Clase encargada de centralizar las rutas y nombres de navegación
/// de la aplicación "Regalos & Esencias".
class AppRoutes {
  // ==========================================
  // CONSTANTES DE NOMBRES DE RUTAS
  // ==========================================

  /// Ruta inicial de la aplicación (pantalla de bienvenida).
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String catalog = '/catalog';
  static const String favorites = '/favorites';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String success = '/success';
  static const String promotions = '/promotions';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/detail';
  static const String profile = '/profile';
  static const String personalData = '/profile/personal-data';

  // ==========================================
  // MAPA DE RUTAS GLOBAL
  // ==========================================
  /// Constructores de pantallas asociados a cada ruta nombrada.
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const WelcomePage(),
      welcome: (context) => const WelcomePage(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      home: (context) => const HomePage(),
      catalog: (context) => const CatalogPage(),
      favorites: (context) => const FavoritesPage(),
      cart: (context) => const CartPage(),
      checkout: (context) => const CheckoutPage(),
      success: (context) => const SuccessPage(),
      promotions: (context) => const PromotionsPage(),
      orders: (context) => const OrdersPage(),
      orderDetail: (context) => const OrderDetailPage(),
      profile: (context) => const ProfilePage(),
      personalData: (context) => const PersonalDataPage(),
    };
  }
}
