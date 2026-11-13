import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';
import '../../app/constants/app_constants.dart';
import 'app_icon.dart';

/// Logotipo de la marca "Regalos & Esencias".
///
/// Equivale al componente `Brand` del proyecto React original.
class BrandWidget extends StatelessWidget {
  const BrandWidget({super.key, this.light = false, this.compact = false});

  final bool light;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 32.0 : 43.0;
    final iconSize = compact ? 18.0 : 25.0;
    final textSize = compact ? 15.0 : 23.0;
    final textColor = light ? Colors.white : AppTheme.wine;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: -7 * math.pi / 180,
          child: Container(
            width: markSize,
            height: markSize,
            decoration: BoxDecoration(
              color: light ? Colors.white24 : AppTheme.wine,
              border: light
                  ? Border.all(color: Colors.white54, width: 1)
                  : null,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(markSize * 0.5),
                topRight: Radius.circular(markSize * 0.5),
                bottomRight: Radius.circular(markSize * 0.44),
                bottomLeft: Radius.circular(markSize * 0.56),
              ),
            ),
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: 7 * math.pi / 180,
              child: AppIcon('sparkle',
                  size: iconSize, color: Colors.white, strokeWidth: 1.8),
            ),
          ),
        ),
        SizedBox(width: compact ? 7 : 10),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: AppConstants.brandPrimary,
                style: AppTheme.playfair(
                  size: textSize,
                  weight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              TextSpan(
                text: ' ${AppConstants.brandDivider} ',
                style: AppTheme.playfair(
                  size: textSize,
                  weight: FontWeight.w500,
                  color: AppTheme.gold,
                ),
              ),
              TextSpan(
                text: AppConstants.brandSecondary,
                style: AppTheme.playfair(
                  size: textSize,
                  weight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
