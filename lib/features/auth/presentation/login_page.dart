import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../app/config/app_routes.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/labeled_field.dart';
import '../data/auth_error_message.dart';
import '../data/auth_repository.dart';
import 'register_page.dart';
import 'widgets/auth_widgets.dart';

/// Pantalla de Inicio de Sesión.
///
/// Equivale al componente `AuthScreen` (mode = "login") del proyecto React,
/// conservando la validación contra [AuthRepository].
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// Administra la validación del formulario y el inicio de sesión.
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await AuthRepository.login(
        _emailController.text.trim(),
        _passwordController.text,
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
              eyebrow: 'Qué alegría verte de nuevo',
              title: 'Bienvenida',
              subtitle:
                  'Ingresa para continuar descubriendo detalles especiales.',
            ),
            const SizedBox(height: 25),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                    label: 'Contraseña',
                    controller: _passwordController,
                    hint: 'Mínimo 8 caracteres',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña';
                      }
                      if (value.length < 8) return 'Mínimo 8 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: _isSubmitting ? 'Ingresando...' : 'Iniciar sesión',
                    onPressed: _isSubmitting ? null : _handleLogin,
                  ),
                  const SizedBox(height: 16),
                  AuthSwitch(
                    question: '¿Aún no tienes cuenta?',
                    action: 'Créala ahora',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    ),
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
