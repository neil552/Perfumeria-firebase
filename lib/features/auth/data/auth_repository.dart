import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Repositorio de autenticación y perfiles de usuario en Firebase.
class AuthRepository {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Cuenta Firebase que tiene la sesión activa, o `null` si hay modo invitado.
  static User? get currentUser => _auth.currentUser;

  /// Crea la cuenta en Authentication y guarda el perfil no confidencial en
  /// `users/{uid}`. La contraseña nunca se escribe en Firestore.
  static Future<void> register(
    String name,
    String email,
    String password, {
    String? phone,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase no devolvió el usuario recién creado.');
    }

    await user.updateDisplayName(name);
    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Valida las credenciales con Firebase Authentication.
  static Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Lee los datos del perfil y completa campos ausentes desde Authentication.
  static Future<Map<String, dynamic>> getProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }

    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    final profile = snapshot.data() ?? <String, dynamic>{};
    return {
      'name': profile['name'] ?? user.displayName ?? '',
      'email': profile['email'] ?? user.email ?? '',
      'phone': profile['phone'] ?? '',
    };
  }

  /// Sincroniza el nombre visible de Auth y los datos editables de Firestore.
  ///
  /// El correo no se modifica aquí porque Firebase exige una verificación
  /// adicional para cambiar la dirección asociada a la cuenta.
  static Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }

    await user.updateDisplayName(name);
    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': user.email,
      'phone': phone,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Cierra la sesión activa en Firebase Authentication.
  static Future<void> logout() => _auth.signOut();
}
