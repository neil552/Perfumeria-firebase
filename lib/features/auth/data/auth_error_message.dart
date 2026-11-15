import 'package:firebase_auth/firebase_auth.dart';

/// Convierte códigos de Firebase en mensajes entendibles para la interfaz.
///
/// Los códigos no reconocidos se conservan en el mensaje para facilitar el
/// diagnóstico sin ocultar el error original.
String authErrorMessage(FirebaseException error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'El correo ya está registrado.';
      case 'invalid-email':
        return 'El correo no tiene un formato válido.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Correo o contraseña incorrectos.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'network-request-failed':
        return 'No se pudo conectar. Revisa tu conexión a internet.';
      case 'too-many-requests':
        return 'Hubo demasiados intentos. Espera un momento y vuelve a probar.';
      case 'unauthenticated':
        return 'Inicia sesión para guardar y consultar tus pedidos.';
    }
  }

  if (error.code == 'permission-denied') {
    return 'Firebase rechazó el acceso. Revisa las reglas de Firestore.';
  }
  if (error.code == 'unavailable') {
    return 'Firestore no está disponible. Revisa tu conexión a internet.';
  }

  return 'No se pudo completar la operación de Firebase (${error.code}).';
}
