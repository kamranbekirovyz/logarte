import 'package:dio/dio.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    SharedPreferences cache = await SharedPreferences.getInstance();

    final modifiedData = cache.getString('$logartePrefix${response.requestOptions.path}');
    if (modifiedData != null) {
      response.data = modifiedData;
    }
    handler.next(response);
  }
}
