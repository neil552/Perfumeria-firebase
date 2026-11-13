import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/labeled_field.dart';
import '../data/auth_error_message.dart';
import '../data/auth_repository.dart';
import 'widgets/auth_widgets.dart';

/// Pantalla de Registro de Nuevos Usuarios.
///
/// Equivale al componente `AuthScreen` (mode = "register") del proyecto React,
/// conservando el alta de usuarios en [AuthRepository].
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

/// Controla la validación y el registro de una cuenta nueva.
class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _accepted = false;
  bool _showError = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) return;

    if (!_accepted) {
      setState(() => _showError = true);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await AuthRepository.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        phone: _phoneController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on FirebaseException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authErrorMessage(error)),
          backgroundColor: const Color(0xFFB13B50),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeader(onBack: () => Navigator.pop(context)),
            const SizedBox(height: 15),
            const AuthIntro(
              eyebrow: 'Únete a nuestra comunidad',
              title: 'Crea tu cuenta',
              subtitle:
                  'Guarda tus favoritos y consulta tus pedidos fácilmente.',
            ),
            const SizedBox(height: 25),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabeledField(
                    label: 'Nombre completo',
                    controller: _nameController,
                    hint: 'Ej. Valeria Mendoza',
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Ingrese su nombre'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  LabeledField(
                    label: 'Correo electrónico',
                    controller: _emailController,
                    hint: 'nombre@correo.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return 'Ingrese su correo';
                      if (!v.contains('@')) return 'Correo no válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  LabeledField(
                    label: 'Número de celular',
                    controller: _phoneController,
                    hint: '+51 999 999 999',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  LabeledField(
                    label: 'Contraseña',
                    controller: _passwordController,
                    hint: 'Mínimo 8 caracteres',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Mínimo 8 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  LabeledField(
                    label: 'Confirmar contraseña',
                    controller: _confirmController,
                    hint: 'Repite tu contraseña',
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _TermsCheck(
                    accepted: _accepted,
                    onTap: () => setState(() {
                      _accepted = !_accepted;
                      _showError = false;
                    }),
                  ),
                  if (_showError) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Debes aceptar los términos para continuar.',
                      style: AppTheme.poppins(
                        size: 10,
                        color: const Color(0xFFB13B50),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: _isSubmitting ? 'Creando cuenta...' : 'Crear cuenta',
                    onPressed: _isSubmitting ? null : _handleRegister,
                  ),
                  const SizedBox(height: 16),
                  AuthSwitch(
                    question: '¿Ya tienes una cuenta?',
                    action: 'Inicia sesión',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Casilla de aceptación de términos y condiciones.
class _TermsCheck extends StatelessWidget {
  const _TermsCheck({required this.accepted, required this.onTap});

  final bool accepted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 19,
            height: 19,
            decoration: BoxDecoration(
              color: accepted ? AppTheme.wine : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: accepted ? AppTheme.wine : const Color(0xFFCBBBC1),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: accepted
                ? const AppIcon('check', size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              'Acepto los términos y condiciones',
              style: AppTheme.poppins(size: 11, color: AppTheme.muted),
            ),
          ),
        ],
      ),
    );
  }
}
