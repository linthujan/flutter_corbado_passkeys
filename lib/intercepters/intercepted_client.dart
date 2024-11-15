import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:passkeys_example/intercepters/auth_intercepter.dart';

final http.Client client = InterceptedClient.build(
  interceptors: [
    AuthIntercepter(),
  ],
);
