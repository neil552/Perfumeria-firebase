import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../app/constants/app_constants.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../auth/data/auth_error_message.dart';
import '../../auth/data/auth_repository.dart';
import '../../catalog/data/favorites_repository.dart';
import '../../orders/data/orders_repository.dart';

/// Pantalla del perfil del usuario.
///
/// Equivale al componente `Profile` del proyecto React original.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

/// Construye el resumen del usuario y coordina las acciones del menú.
class _ProfilePageState extends State<ProfilePage> {
  late final Stream<List<OrderModel>> _ordersStream;

  // El texto del segundo campo identifica la acción en _handleMenuTap.
  // Cada fila conserva el icono, título y descripción que presenta la interfaz.
  static const List<List<String>> _menu = [
    ['user', 'Datos personales', 'Nombre, correo y celular'],
    ['bag', 'Mis pedidos', 'Historial y seguimiento'],
    ['heart', 'Mis favoritos', 'Productos que guardaste'],
    ['tag', 'Mis promociones', 'Cupones disponibles'],
    ['phone', 'Contacto', 'Estamos para ayudarte'],
    ['sparkle', 'Preguntas frecuentes', 'Resuelve tus dudas'],
  ];

  @override
  void initState() {
    super.initState();
    _ordersStream = OrdersRepository.watchForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    // El perfil se muestra dentro de la navegación principal y permite
    // desplazarse verticalmente en pantallas pequeñas.
    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        current: AppRoutes.profile,
        onNavigate: (route) => Navigator.pushReplacementNamed(context, route),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            children: [
              const AppHeader(title: 'Mi perfil'),
              const SizedBox(height: 14),
              _buildHero(),
              const SizedBox(height: 17),
              _buildStats(),
              const SizedBox(height: 14),
              _buildMenu(context),
              const SizedBox(height: 18),
              _buildLogout(context),
              const SizedBox(height: 8),
              Text(
                AppConstants.versionText,
                style: AppTheme.poppins(
                  size: 6,
                  color: const Color(0xFFAE9DA3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Muestra la identidad disponible en Firebase Authentication.
  ///
  /// Las iniciales se derivan de las primeras dos palabras del nombre; si aún
  /// no existe un nombre registrado, se presenta un signo de interrogación.
  Widget _buildHero() {
    final user = AuthRepository.currentUser;
    final name = user?.displayName ?? 'Cliente';
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join()
        .toUpperCase();

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE7CBD6), Color(0xFFC98EA5)],
                ),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF74465A).withValues(alpha: 0.15),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                initials.isEmpty ? '?' : initials,
                style: AppTheme.playfair(
                  size: 22,
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              right: -2,
              bottom: 2,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: AppTheme.wine,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: const AppIcon('sparkle', size: 13, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(name, style: AppTheme.playfair(size: 24, weight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(
          user?.email ?? '',
          style: AppTheme.poppins(size: 9, color: AppTheme.muted),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E1C5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Cliente Esencia',
            style: AppTheme.poppins(size: 7, color: const Color(0xFF8D692D)),
          ),
        ),
      ],
    );
  }

  /// Resume los pedidos de Firestore y los favoritos de esta sesión.
  ///
  /// El cupón es un dato demostrativo fijo y no representa una cuenta real
  /// sincronizada con el backend.
  Widget _buildStats() {
    return StreamBuilder<List<OrderModel>>(
      stream: _ordersStream,
      builder: (context, snapshot) {
        final count = snapshot.hasData
            ? snapshot.data!.length.toString()
            : snapshot.hasError
            ? '!'
            : '…';
        final stats = [
          [count, 'Pedidos'],
          [FavoritesRepository.productIds.value.length.toString(), 'Favoritos'],
          ['1', 'Cupón'],
        ];
        final error = snapshot.error;
        final errorMessage = error == null
            ? null
            : error is FirebaseException
            ? authErrorMessage(error)
            : 'No se pudo cargar el número de pedidos.';

        return Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: AppTheme.poppins(
                    size: 8,
                    color: const Color(0xFFB13B50),
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < stats.length; i++)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: i < stats.length - 1
                              ? const Border(
                                  right: BorderSide(color: AppTheme.line),
                                )
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            Text(
                              stats[i][0],
                              style: AppTheme.playfair(
                                size: 18,
                                weight: FontWeight.w600,
                                color: AppTheme.wine,
                              ),
                            ),
                            Text(
                              stats[i][1],
                              style: AppTheme.poppins(
                                size: 7,
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Genera las opciones del perfil a partir de la configuración _menu.
  ///
  /// El título de cada opción debe coincidir con un caso de
  /// [_handleMenuTap], que define su navegación o diálogo.
  Widget _buildMenu(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _menu.length; i++)
            GestureDetector(
              onTap: () => _handleMenuTap(_menu[i][1]),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: i < _menu.length - 1
                      ? const Border(
                          bottom: BorderSide(color: Color(0xFFEEE5E1)),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E6EB),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      alignment: Alignment.center,
                      child: AppIcon(
                        _menu[i][0],
                        size: 20,
                        color: AppTheme.wine,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _menu[i][1],
                            style: AppTheme.poppins(
                              size: 9,
                              weight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _menu[i][2],
                            style: AppTheme.poppins(
                              size: 7,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const AppIcon('chevron', size: 18, color: AppTheme.plum),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Ejecuta la acción correspondiente a la opción seleccionada.
  ///
  /// Las pantallas abiertas encima del perfil se cierran al volver; en esos
  /// casos se actualiza el resumen para reflejar los datos recién modificados.
  Future<void> _handleMenuTap(String label) async {
    switch (label) {
      case 'Datos personales':
        final updated = await Navigator.pushNamed<bool>(
          context,
          AppRoutes.personalData,
        );
        if (mounted) {
          setState(() {});
          if (updated == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Datos actualizados.')),
            );
          }
        }
      case 'Mis pedidos':
        Navigator.pushReplacementNamed(context, AppRoutes.orders);
      case 'Mis favoritos':
        await Navigator.pushNamed(context, AppRoutes.favorites);
        if (mounted) setState(() {});
      case 'Mis promociones':
        Navigator.pushReplacementNamed(context, AppRoutes.promotions);
      case 'Contacto':
        await _showContactDialog();
      case 'Preguntas frecuentes':
        await _showFaqDialog();
    }
  }

  /// Informa que los datos comerciales de contacto aún no están configurados.
  Future<void> _showContactDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contacto'),
        content: const Text(
          'La atención al cliente todavía no tiene un correo o teléfono '
          'configurado en esta versión de demostración.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Muestra respuestas estáticas sobre las funciones disponibles en la demo.
  Future<void> _showFaqDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preguntas frecuentes'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Puedo personalizar un regalo?\n'
                'Sí. En los productos personalizables puedes elegir empaque y tarjeta.',
              ),
              SizedBox(height: 12),
              Text(
                '¿Se realiza un cobro real?\n'
                'No. El checkout de esta aplicación es demostrativo y no procesa pagos.',
              ),
              SizedBox(height: 12),
              Text(
                '¿Dónde reviso mis pedidos?\n'
                'Entra a Mi perfil y selecciona Mis pedidos.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Cierra Firebase Authentication y elimina las pantallas anteriores.
  ///
  /// Se reemplaza toda la pila de navegación para que el botón Atrás no
  /// regrese a una pantalla que requiere una sesión activa.
  Future<void> _handleLogout(BuildContext context) async {
    try {
      await AuthRepository.logout();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.welcome,
        (route) => false,
      );
    } on FirebaseException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authErrorMessage(error)),
          backgroundColor: const Color(0xFFB13B50),
        ),
      );
    }
  }

  /// Presenta la acción de cierre de sesión en la parte inferior del perfil.
  Widget _buildLogout(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleLogout(context),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIcon('logout', size: 19, color: Color(0xFFA85664)),
            const SizedBox(width: 7),
            Text(
              'Cerrar sesión',
              style: AppTheme.poppins(size: 9, color: const Color(0xFFA85664)),
            ),
          ],
        ),
      ),
    );
  }
}
