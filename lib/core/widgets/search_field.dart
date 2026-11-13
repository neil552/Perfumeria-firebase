import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';
import 'app_icon.dart';

/// Campo de búsqueda reutilizable.
///
/// Equivale a la clase CSS `.search-bar` del proyecto React original.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    this.onSubmitted,
    this.onChanged,
    this.trailing,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEEE3DF)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const AppIcon('search', size: 20, color: Color(0xFFA18D95)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: AppTheme.poppins(size: 12, color: AppTheme.plum),
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle:
                    AppTheme.poppins(size: 12, color: const Color(0xFFA18D95)),
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Botón circular/redondeado usado junto al campo de búsqueda.
class SearchTrailingButton extends StatelessWidget {
  const SearchTrailingButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Color(0xFFF3E5EB),
          shape: BoxShape.circle,
        ),
        child: AppIcon(icon, size: 18, color: AppTheme.wine),
      ),
    );
  }
}
