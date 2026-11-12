import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../../app/config/app_routes.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/labeled_field.dart';
import '../../auth/data/auth_error_message.dart';
import '../../auth/data/auth_repository.dart';

/// Consulta y actualiza el perfil del usuario autenticado en Firestore.
///
/// El correo se muestra como solo lectura; para cambiarlo se requiere el flujo
/// de verificación de correo de Firebase Authentication.
class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({super.key});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

/// Administra la carga, validación y guardado del formulario de perfil.
class _PersonalDataPageState extends State<PersonalDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // La carga es asíncrona porque el perfil se obtiene de Firestore.
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (AuthRepository.currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final profile = await AuthRepository.getProfile();
      if (!mounted) return;
      _nameController.text = profile['name'] as String;
      _emailController.text = profile['email'] as String;
      _phoneController.text = profile['phone'] as String;
    } on FirebaseException catch (error) {
      if (!mounted) return;
      _showMessage(authErrorMessage(error), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Valida el formulario, guarda el perfil y devuelve `true` al cerrar.
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await AuthRepository.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      if (!mounted) return;
      _showMessage('Tus datos personales fueron actualizados.');
      Navigator.pop(context, true);
    } on FirebaseException catch (error) {
      if (!mounted) return;
      _showMessage(authErrorMessage(error), isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFB13B50) : AppTheme.plum,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (AuthRepository.currentUser == null) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: 'Datos personales',
                onBack: () => Navigator.pop(context),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Inicia sesión para consultar y editar tus datos.',
                      textAlign: TextAlign.center,
                      style: AppTheme.poppins(size: 13, color: AppTheme.plum),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: 'Iniciar sesión',
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => route.settings.name == AppRoutes.welcome,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppHeader(
                      title: 'Datos personales',
                      onBack: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 18),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          LabeledField(
                            label: 'Nombre completo',
                            controller: _nameController,
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                ? 'Ingresa tu nombre'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          LabeledField(
                            label: 'Correo electrónico',
                            controller: _emailController,
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'El correo se administra desde tu cuenta de acceso.',
                              style: AppTheme.poppins(
                                size: 8,
                                color: AppTheme.muted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          LabeledField(
                            label: 'Número de celular',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            label: _isSaving
                                ? 'Guardando...'
                                : 'Guardar cambios',
                            onPressed: _isSaving ? null : _save,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
