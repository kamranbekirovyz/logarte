import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    SharedPreferences cache = await SharedPreferences.getInstance();

    final key = '$logartePrefix${response.requestOptions.uri}';
    print('Logarte key: $key');
    final modifiedData = cache.getString(key);
    print('Mock response found: $modifiedData');
    if (modifiedData != null) {
      response.data = jsonDecode(modifiedData);
    }
    handler.next(response);
  }
}
