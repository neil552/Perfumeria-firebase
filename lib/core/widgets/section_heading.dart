import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';

/// Encabezado de sección con etiqueta superior, título y acción opcional.
///
/// Equivale a la clase CSS `.section-heading` del proyecto React original.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String eyebrow;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: AppTheme.poppins(
                  size: 8,
                  weight: FontWeight.w600,
                  color: AppTheme.wine,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: AppTheme.playfair(
                  size: 21,
                  weight: FontWeight.w600,
                  color: AppTheme.plum,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTheme.poppins(
                size: 10,
                weight: FontWeight.w600,
                color: AppTheme.wine,
              ),
            ),
          ),
      ],
    );
  }
}
