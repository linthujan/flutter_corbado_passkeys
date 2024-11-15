import 'dart:convert';

import 'package:passkeys/authenticator.dart';
import 'package:passkeys_example/api_services/auth.dart';
import 'package:passkeys_example/local_relying_party_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService({required this.rps, required this.authenticator});

  final LocalRelyingPartyServer rps;
  final PasskeyAuthenticator authenticator;

  Future<void> loginWithPassword(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final fcmToken = prefs.getString('fcm_token');

    final loginData = (await passwordLogin(
      email,
      password,
      jsonDecode(fcmToken!) as String,
      'ANDROID',
    ))!;

    await prefs.setString('user', jsonEncode(loginData.data?['user']));
    await prefs.setString('token', jsonEncode(loginData.data?['token']));
  }

  Future<void> loginWithPasskey({required String email}) async {
    final rps1 = await rps.startPasskeyLogin(email);
    final authenticatorRes = await authenticator.authenticate(rps1);
    await rps.finishPasskeyLogin(authenticatorRes);
  }

  Future<void> loginWithPasskeyConditionalUI() async {
    final rps1 = rps.startPasskeyLoginConditionalU();
    final authenticatorRes = await authenticator.authenticate(rps1);
    rps.finishPasskeyLoginConditionalUI(response: authenticatorRes);
  }

  Future<void> setPasskey() async {
    final rps1 = await rps.startPasskeyRegister();
    final authenticatorRes = await authenticator.register(rps1);
    await rps.finishPasskeyRegister(authenticatorRes);
  }
}
