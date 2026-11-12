import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';

/// Imagen remota con manejo de carga y error.
///
/// Reutiliza las mismas URLs del proyecto de referencia para conservar
/// los recursos gráficos originales.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: AppTheme.line,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined,
            color: AppTheme.muted, size: 22),
      ),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: AppTheme.line,
        );
      },
    );
  }
}
