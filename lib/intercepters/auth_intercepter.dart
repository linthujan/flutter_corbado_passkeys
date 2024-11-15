import 'dart:async';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:passkeys_example/helper/common.dart';

class AuthIntercepter implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final token = await getToken();

    print('token : $token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return false;
  }
}
