import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';
import 'app_icon.dart';
import 'brand.dart';

/// Encabezado superior reutilizable de las pantallas internas.
///
/// Equivale al componente `AppHeader` del proyecto React original:
/// botón de retroceso (o logotipo) a la izquierda, título centrado y
/// acceso al carrito con contador a la derecha.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.title,
    this.onBack,
    this.onCart,
    this.cartCount = 0,
  });

  final String? title;
  final VoidCallback? onBack;
  final VoidCallback? onCart;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        children: [
          Row(
            children: [
              if (onBack != null)
                _CircleButton(icon: 'arrow', onTap: onBack!)
              else
                const BrandWidget(compact: true),
              const Spacer(),
              if (onCart != null)
                _CircleButton(
                  icon: 'cart',
                  onTap: onCart!,
                  badge: cartCount > 0 ? cartCount : null,
                )
              else
                const SizedBox(width: 42),
            ],
          ),
          if (title != null)
            Positioned(
              left: 52,
              right: 52,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTheme.poppins(
                    size: 18,
                    weight: FontWeight.w600,
                    color: AppTheme.plum,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Botón circular blanco (retroceso o carrito) con contador opcional.
class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap, this.badge});

  final String icon;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.plum.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: AppIcon(icon, size: 22, color: AppTheme.plum),
          ),
          if (badge != null)
            Positioned(
              right: -2,
              top: -3,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppTheme.wine,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.cream, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$badge',
                  style: AppTheme.poppins(
                    size: 10,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
