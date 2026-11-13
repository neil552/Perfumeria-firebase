import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';
import 'app_icon.dart';

/// Botón principal del diseño (relleno vino, esquinas de 15).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.iconName,
    this.backgroundColor,
    this.foregroundColor,
    this.compact = false,
    this.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? iconName;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool compact;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppTheme.wine;
    final fg = foregroundColor ?? Colors.white;

    return _BaseButton(
      onPressed: onPressed,
      minHeight: compact ? 42 : 52,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppTheme.wine.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconName != null) ...[
            AppIcon(iconName!, size: 20, color: fg),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTheme.poppins(
                size: 14,
                weight: FontWeight.w600,
                color: fg,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Botón secundario del diseño (contorno rosa, texto vino).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.foregroundColor,
    this.borderColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      onPressed: onPressed,
      minHeight: 52,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor ?? const Color(0xFFC991AA), width: 1.5),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTheme.poppins(
          size: 14,
          weight: FontWeight.w600,
          color: foregroundColor ?? AppTheme.wine,
        ),
      ),
    );
  }
}

/// Estructura común de los botones con ancho completo.
class _BaseButton extends StatelessWidget {
  const _BaseButton({
    required this.onPressed,
    required this.minHeight,
    required this.decoration,
    required this.child,
  });

  final VoidCallback? onPressed;
  final double minHeight;
  final BoxDecoration decoration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: decoration,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
