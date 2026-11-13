import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';

/// Pie de acción fijo en la parte inferior de la pantalla.
///
/// Equivale a la clase CSS `.action-footer` del proyecto React original.
class ActionFooter extends StatelessWidget {
  const ActionFooter({super.key, required this.child, this.note});

  final Widget child;

  /// Texto aclaratorio opcional mostrado debajo del botón.
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFDFBFA),
        border: Border(top: BorderSide(color: AppTheme.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              if (note != null) ...[
                const SizedBox(height: 7),
                Text(
                  note!,
                  textAlign: TextAlign.center,
                  style: AppTheme.poppins(
                    size: 8,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
