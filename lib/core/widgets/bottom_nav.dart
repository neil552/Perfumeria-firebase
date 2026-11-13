import 'package:flutter/material.dart';

import '../../app/config/app_routes.dart';
import '../../app/config/app_theme.dart';
import 'app_icon.dart';

/// Elemento de la barra de navegación inferior.
class NavItem {
  const NavItem({required this.route, required this.label, required this.icon});

  final String route;
  final String label;
  final String icon;
}

/// Barra de navegación inferior con las cinco secciones principales.
///
/// Equivale al componente `BottomNav` del proyecto React original.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.current,
    required this.onNavigate,
  });

  final String current;
  final ValueChanged<String> onNavigate;

  static const List<NavItem> items = [
    NavItem(route: AppRoutes.home, label: 'Inicio', icon: 'home'),
    NavItem(route: AppRoutes.catalog, label: 'Categorías', icon: 'grid'),
    NavItem(route: AppRoutes.promotions, label: 'Promos', icon: 'tag'),
    NavItem(route: AppRoutes.orders, label: 'Pedidos', icon: 'bag'),
    NavItem(route: AppRoutes.profile, label: 'Perfil', icon: 'user'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFFEFD),
        border: Border(top: BorderSide(color: AppTheme.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 78,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final item in items)
                _NavButton(
                  item: item,
                  active: current == item.route,
                  onTap: () => onNavigate(item.route),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renderiza una opción de navegación y marca visualmente la sección activa.
class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.wine : const Color(0xFFA49198);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(item.icon, size: 21, color: color),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTheme.poppins(
                size: 8,
                weight: active ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
