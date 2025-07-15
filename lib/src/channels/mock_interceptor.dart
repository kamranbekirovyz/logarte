import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    SharedPreferences cache = await SharedPreferences.getInstance();

    cache.getKeys().forEach((e) {
      print('Key: $e =END=');
    });
    final modifiedData = cache.getString(response.requestOptions.path);
    print('response.requestOptions.uri.path: ${response.requestOptions.path}');
    print('Modified data: $modifiedData');
    if (modifiedData != null) {
      response.data = modifiedData;
    }
    handler.next(response);
  }
}
