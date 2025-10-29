import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/facebook_auth_service.dart';

final facebookAuthServiceProvider = Provider<FacebookAuthService>((ref) {
  return FacebookAuthService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  final facebookAuthService = ref.watch(facebookAuthServiceProvider);
  return AuthService(facebookAuthService);
});

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookAuthService _facebookAuthService;

  AuthService(this._facebookAuthService);

  Future<User?> signInEmail(String email, String password) => _auth
      .signInWithEmailAndPassword(email: email, password: password)
      .then((cred) => cred.user);

  Future<User?> registerEmail(String email, String password) => _auth
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((cred) => cred.user);

  Future<User?> signInWithFacebook() async {
    final accessToken = await _facebookAuthService.login();
    if (accessToken == null) return null;

    final credential = FacebookAuthProvider.credential(accessToken.tokenString);

    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() async {
    // Logout do Firebase
    await _auth.signOut();

    // Logout do Facebook
    await _facebookAuthService.signOut();
  }
}
