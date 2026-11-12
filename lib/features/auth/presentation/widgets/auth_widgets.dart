import 'package:flutter/material.dart';

import '../../../../app/config/app_theme.dart';
import '../../../../core/widgets/app_icon.dart';

/// Cabecera de introducción de las pantallas de autenticación.
class AuthIntro extends StatelessWidget {
  const AuthIntro({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.rotate(
          angle: -6 * 3.1415926 / 180,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEEDCE4),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const AppIcon('sparkle', size: 22, color: AppTheme.wine),
          ),
        ),
        const SizedBox(height: 14),
        Text(eyebrow, style: AppTheme.eyebrow()),
        const SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.playfair(size: 34, weight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTheme.poppins(size: 12, color: AppTheme.muted, height: 1.6),
        ),
      ],
    );
  }
}

/// Enlace inferior para alternar entre iniciar sesión y crear cuenta.
class AuthSwitch extends StatelessWidget {
  const AuthSwitch({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  final String question;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$question ',
          style: AppTheme.poppins(size: 11, color: AppTheme.muted),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: AppTheme.poppins(
              size: 11,
              weight: FontWeight.w600,
              color: AppTheme.wine,
            ),
          ),
        ),
      ],
    );
  }
}
