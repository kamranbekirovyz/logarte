import 'package:dio/dio.dart';
import 'package:logarte/logarte.dart';

class LogarteDioInterceptor extends Interceptor {
  final Logarte _logarte;

  LogarteDioInterceptor(this._logarte);

  final _cache = <RequestOptions, DateTime>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _cache[options] = DateTime.now();

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final Map<String, String> responseHeaders = response.headers.map.map(
      (key, value) => MapEntry(key, value.join(', ')),
    );
    final sentAt = _cache[response.requestOptions];
    final receivedAt = DateTime.now();

    _logarte.network(
      request: NetworkRequestLogarteEntry(
        url: response.requestOptions.uri.toString(),
        method: response.requestOptions.method,
        headers: response.requestOptions.headers,
        body: response.requestOptions.data,
        sentAt: sentAt,
      ),
      response: NetworkResponseLogarteEntry(
        statusCode: response.statusCode,
        headers: responseHeaders,
        body: response.data,
        receivedAt: receivedAt,
      ),
    );

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final Map<String, String>? responseHeaders = err.response?.headers.map.map(
      (key, value) => MapEntry(key, value.join(', ')),
    );

    _logarte.network(
      request: NetworkRequestLogarteEntry(
        url: err.requestOptions.uri.toString(),
        method: err.requestOptions.method,
        headers: err.requestOptions.headers,
        body: err.requestOptions.data,
      ),
      response: NetworkResponseLogarteEntry(
        statusCode: err.response?.statusCode ?? 0,
        headers: responseHeaders,
        body: err.response?.data,
      ),
    );

    return super.onError(err, handler);
  }
}
