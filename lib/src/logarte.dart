import 'dart:developer' as developer;

import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/logarte_entry.dart';

class Logarte {
  static final logs = <LogarteEntry>[];
  static String password = '123456';

  static void log(String message) {
    developer.log(message);
  }

  static void logNetwork({
    required NetworkRequestLogarteEntry request,
    required NetworkResponseLogarteEntry response,
  }) {
    // TODO: try catch
    log('''
------------------ NETWORK REQUEST -----------------
URL: [${request.method}] ${request.url}
REQUEST HEADERS: ${request.headers.prettyJson}
REQUEST BODY: ${request.body.prettyJson}
STATUS CODE: ${response.statusCode}
RESPONSE HEADERS: ${response.headers.prettyJson}
RESPONSE BODY: ${response.body.prettyJson}
----------------------------------------------------
''');

    logs.add(NetworkLogarteEntry(request: request, response: response));
  }
}
