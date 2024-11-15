import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passkeys/types.dart';
import 'package:passkeys_example/api_services/index.dart';
import 'package:passkeys_example/helper/common.dart';
import 'package:passkeys_example/models/http_model.dart';

Future<HttpResponseModel?> getRegisterOption() async {
  final token = await getToken();
  print(token);

  final response = await http.get(
    Uri.parse('$baseurl/auth/register-passkey'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  final data = HttpResponseModel.fromJSON(jsonDecode(response.body));
  if (data.status) {
    return data;
  } else if (data.error?['isAppError'] == true) {
    throw Exception(data.meta.message);
  } else {
    throw Exception('Passkey register options failed');
  }
}

Future<HttpResponseModel?> verifyRegister(RegisterResponseType payload) async {
  final token = await getToken();

  final response = await http.post(
    Uri.parse('$baseurl/auth/register-passkey'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'response': {
        'rawId': payload.rawId,
        'id': payload.id,
        'response': {
          'clientDataJSON': payload.clientDataJSON,
          'attestationObject': payload.attestationObject,
        },
        'type': 'public-key',
      },
    }),
  );

  final data = HttpResponseModel.fromJSON(jsonDecode(response.body));
  if (data.status) {
    return data;
  } else if (data.error?['isAppError'] == true) {
    throw Exception(data.meta.message);
  } else {
    throw Exception('Passkey verify failed');
  }
}

Future<HttpResponseModel?> getLoginOption(String fcmToken) async {
  final response = await http.get(
    Uri.parse('$baseurl/auth/login-passkey?fcm_token=$fcmToken'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  final data = HttpResponseModel.fromJSON(jsonDecode(response.body));
  if (data.status) {
    return data;
  } else if (data.error?['isAppError'] == true) {
    throw Exception(data.meta.message);
  } else {
    throw Exception('Passkey login options failed');
  }
}

Future<HttpResponseModel?> verifyLogin(
  AuthenticateResponseType payload,
) async {
  final response = await http.post(
    Uri.parse('$baseurl/auth/login-passkey'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'response': {
        'rawId': payload.rawId,
        'id': payload.id,
        'response': {
          'clientDataJSON': payload.clientDataJSON,
          'signature': payload.signature,
          'authenticatorData': payload.authenticatorData,
          'userHandle': payload.userHandle,
        },
        'type': 'public-key',
      },
    }),
  );

  final data = HttpResponseModel.fromJSON(jsonDecode(response.body));
  if (data.status) {
    return data;
  } else if (data.error?['isAppError'] == true) {
    throw Exception(data.meta.message);
  } else {
    throw Exception('Passkey login failed');
  }
}
