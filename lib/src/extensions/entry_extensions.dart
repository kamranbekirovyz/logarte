import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logarte/logarte.dart';

extension LogarteNetworkEntryXs on NetworkLogarteEntry {
  String get asReadableDuration {
    if (request.sentAt == null || response.receivedAt == null) {
      return 'N/A ms';
    }

    return '${response.receivedAt!.difference(request.sentAt!).inMilliseconds} ms';
  }

  String toCurlCommand() {
    final components = <String>['curl'];

    if (request.method.toUpperCase() != 'GET') {
      components.add("-X ${request.method.toUpperCase()}");
    }

    if (request.headers != null) {
      final headers = request.headers ?? {};
      headers.forEach((key, value) {
        components.add("-H '${_escape(key)}: ${_escape(value.toString())}'");
      });
    }

    if (request.body != null) {
      var body = request.body;

      // FormData can't be JSON-serialized, so keep only their fields attributes
      if (body is FormData) {
        body = Map.fromEntries(body.fields);
      }

      final bodyString = body is String ? body : jsonEncode(body);
      components.add("-d '${_escape(bodyString)}'");
    }

    components.add("'${request.url}'");

    return components.join(' ');
  }

  String _escape(String input) {
    return input.replaceAll("'", r"'\''");
  }
}
