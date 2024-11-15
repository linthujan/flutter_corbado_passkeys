import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:passkeys_example/api_services/index.dart';
import 'package:passkeys_example/helper/common.dart';
import 'package:passkeys_example/models/http_model.dart';

Future<HttpResponseModel?> passwordLogin(
  String email,
  String password,
  String fcmToken,
  String platform,
) async {
  final response = await http.post(
    Uri.parse('$baseurl/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
      'platform': platform,
    }),
  );

  final data = HttpResponseModel.fromJSON(jsonDecode(response.body));
  if (data.status) {
    return data;
  } else if (data.error?['isAppError'] == true) {
    throw Exception(data.meta.message);
  } else {
    throw Exception('Login failed');
  }
}

Future<HttpResponseModel?> getProfile() async {
  final token = await getToken();

  final response = await http
      .get(Uri.parse('$baseurl/auth/profile'), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $token'
  });

  final data = HttpResponseModel.fromJSON(jsonDecode(response.body));
  if (data.status) {
    return data;
  } else if (data.error?['isAppError'] == true) {
    throw Exception(data.meta.message);
  } else {
    throw Exception('Get profile failed');
  }
}
