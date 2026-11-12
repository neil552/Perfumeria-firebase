# Perfumería

Aplicación Flutter para una tienda de regalos y esencias.

## Configurar Firebase para Android

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/).
2. Agrega una aplicación Android con el identificador `com.example.perfumeria`.
   Si cambias `applicationId` en `android/app/build.gradle.kts`, registra ese
   mismo identificador en Firebase.
3. Ejecuta `flutterfire configure --project <id-del-proyecto> --platforms android`
   para generar `lib/firebase_options.dart`.
4. Descarga `google-services.json` y colócalo en `android/app/google-services.json`.
5. En **Authentication → Sign-in method**, habilita **Correo electrónico/contraseña**.
6. Crea una base de datos en **Firestore Database**. Copia las reglas de
   `firestore.rules` en la pestaña **Rules** y publícalas.
7. Ejecuta `flutter pub get` y luego `flutter run`.

El registro e inicio de sesión usan Firebase Authentication. Los perfiles se
guardan en `users/{uid}` en Firestore. El catálogo y sus imágenes siguen siendo
locales; favoritos y pedidos nuevos se mantienen en memoria y se reinician al
cerrar la app. Esta versión no usa Firebase Storage ni procesa pagos reales. No
subas el archivo de cuenta de servicio ni claves privadas al proyecto Flutter.
