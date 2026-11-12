import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/config/app_theme.dart';
import 'app/config/app_routes.dart';
import 'firebase_options.dart';

// ==========================================
// PUNTO DE ENTRADA DE LA APLICACIÓN
// ==========================================
/// Prepara el binding de Flutter y Firebase antes de crear cualquier pantalla.
///
/// Las opciones se seleccionan por plataforma para que cada instalación use
/// la aplicación Firebase que le corresponde (Android, iOS o web).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RegalosEsenciasApp());
}

/// Configura el tema y el mapa de navegación de "Regalos & Esencias".
class RegalosEsenciasApp extends StatelessWidget {
  const RegalosEsenciasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Título de la aplicación (visible en el sistema operativo)
      title: 'Regalos & Esencias',

      // Oculta la etiqueta de modo "DEBUG" en la esquina superior derecha
      debugShowCheckedModeBanner: false,

      // Asigna el tema global configurado con Material Design 3 y los colores oficiales
      theme: AppTheme.lightTheme,

      // Define cuál será la primera ruta en mostrarse al abrir la app
      initialRoute: AppRoutes.welcome,

      // Carga el mapa de rutas centralizado que definimos en AppRoutes
      routes: AppRoutes.routes,
    );
  }
}
