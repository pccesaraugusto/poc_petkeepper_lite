import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  // Faz login e retorna o AccessToken
  Future<AccessToken?> login() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      return result.accessToken;
    } else {
      print('Erro no login Facebook: ${result.status}, ${result.message}');
      return null;
    }
  }

  // Faz logout do Facebook
  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
  }

  // Obtém dados do usuário logado
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      return await FacebookAuth.instance.getUserData();
    } catch (e) {
      print('Erro ao obter dados do usuário Facebook: $e');
      return null;
    }
  }
}
