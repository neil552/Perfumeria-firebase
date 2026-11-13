import 'package:flutter/material.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../app/constants/app_constants.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/brand.dart';
import '../../../core/widgets/custom_button.dart';

/// Pantalla de bienvenida.
///
/// Equivale al componente `Welcome` del proyecto React original.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(
            url: AppImages.hero,
            fit: BoxFit.cover,
            alignment: const Alignment(0.16, 0),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x452F1E29),
                  Color(0x3338232D),
                  Color(0xE83E2735),
                  Color(0xFF3E2735),
                ],
                stops: [0.0, 0.38, 0.68, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: BrandWidget(light: true),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Detalles que hablan por ti',
                    textAlign: TextAlign.center,
                    style: AppTheme.eyebrow(color: const Color(0xFFF5D6E2)),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Regala emociones,\n',
                          style: AppTheme.playfair(
                            size: 40,
                            weight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.05,
                          ),
                        ),
                        TextSpan(
                          text: 'deja huella.',
                          style: AppTheme.playfair(
                            size: 40,
                            weight: FontWeight.w500,
                            color: const Color(0xFFEFD2DC),
                            height: 1.05,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Encuentra regalos únicos y fragancias inolvidables para cada historia.',
                    textAlign: TextAlign.center,
                    style: AppTheme.poppins(
                      size: 13,
                      color: const Color(0xD6F8EDF1),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 23),
                  PrimaryButton(
                    label: 'Iniciar sesión',
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.wine,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.login),
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(
                    label: 'Crear cuenta',
                    foregroundColor: Colors.white,
                    borderColor: const Color(0x99FFFFFF),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.register),
                  ),
                  const SizedBox(height: 16),
                  _GuestButton(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Enlace de texto "Continuar como invitado".
class _GuestButton extends StatelessWidget {
  const _GuestButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Continuar como invitado',
                style: AppTheme.poppins(
                  size: 12,
                  color: const Color(0xFFF9EAF0),
                ),
              ),
              const SizedBox(width: 4),
              const AppIcon('chevron', size: 16, color: Color(0xFFF9EAF0)),
            ],
          ),
        ),
      ),
    );
  }
}
