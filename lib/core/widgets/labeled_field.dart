import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';

/// Campo de texto con etiqueta superior, usado en formularios y checkout.
///
/// Reproduce el estilo de `.form-stack label` / `.checkout-card input`
/// del proyecto React original.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  }) : assert(controller == null || initialValue == null,
            'No uses controller e initialValue a la vez');

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final int? maxLength;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.poppins(
            size: 11,
            weight: FontWeight.w600,
            color: AppTheme.plum,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          maxLength: maxLength,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          style: AppTheme.poppins(size: 12, color: AppTheme.plum),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppTheme.poppins(size: 12, color: const Color(0xFFA18D95)),
            prefixIcon: prefixIcon,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: AppTheme.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: AppTheme.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: AppTheme.pink),
            ),
            errorStyle: AppTheme.poppins(size: 10, color: const Color(0xFFB13B50)),
          ),
        ),
      ],
    );
  }
}
