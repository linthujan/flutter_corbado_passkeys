import 'dart:convert';

import 'package:passkeys/types.dart';
import 'package:passkeys_example/api_services/passkey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRelyingPartyServer {
  LocalRelyingPartyServer();

  Future<RegisterRequestType> startPasskeyRegister() async {
    final data = (await getRegisterOption())!;
    final options = data.data;

    final challenge = options['challenge'] as String;

    final rp = RelyingPartyType(
      name: options['rp']['name'] as String,
      id: options['rp']['id'] as String,
    );

    final user = UserType(
      displayName: options['user']['name'] as String,
      name: options['user']['name'] as String,
      id: options['user']['id'] as String,
    );

    final authenticatorSelection = AuthenticatorSelectionType(
      authenticatorAttachment: 'platform',
      requireResidentKey: false,
      residentKey: 'required',
      userVerification: 'preferred',
    );

    return RegisterRequestType(
      challenge: challenge,
      relyingParty: rp,
      user: user,
      authSelectionType: authenticatorSelection,
      pubKeyCredParams: [
        PubKeyCredParamType(type: 'public-key', alg: -257),
      ],
      excludeCredentials: [],
    );
  }

  Future<void> finishPasskeyRegister(RegisterResponseType response) async {
    (await verifyRegister(response))!;
  }

  Future<AuthenticateRequestType> startPasskeyLogin(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final fcmToken = prefs.getString('fcm_token');

    final data = (await getLoginOption(jsonDecode(fcmToken!) as String))!;
    final challenge = data.data['challenge'] as String;

    final allowed = data.data['allowCredentials'] as List;

    final allowCredentials = <CredentialType>[];
    for (final credential in allowed) {
      final transports = <String>[];
      credential['transports']
          .forEach((dynamic transport) => transports.add(transport as String));
      allowCredentials.add(
        CredentialType(
          id: credential['id'] as String,
          type: credential['type'] as String,
          transports: transports,
        ),
      );
    }

    print("allowCredentials ${allowCredentials.length}");

    return AuthenticateRequestType(
      relyingPartyId: data.data['rpId'] as String,
      challenge: challenge,
      mediation: MediationType.Optional,
      preferImmediatelyAvailableCredentials: false,
      allowCredentials: allowCredentials,
    );
  }

  Future<void> finishPasskeyLogin(AuthenticateResponseType response) async {
    (await verifyLogin(
      response,
    ))!;
  }

  AuthenticateRequestType startPasskeyLoginConditionalU() {
    final challenge = 'generateChallenge';

    return AuthenticateRequestType(
      relyingPartyId: 'rpID',
      challenge: challenge,
      mediation: MediationType.Conditional,
      preferImmediatelyAvailableCredentials: false,
    );
  }

  void finishPasskeyLoginConditionalUI({
    required AuthenticateResponseType response,
  }) {}
}
