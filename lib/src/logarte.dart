import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/console/logarte_auth_screen.dart';
import 'package:logarte/src/models/logarte_entry.dart';

class Logarte {
  final String consolePassword;
  final Function(String data)? onShare;

  Logarte({
    required this.consolePassword,
    this.onShare,
  });

  final logs = <LogarteEntry>[];

  void log(String message) {
    developer.log(message);
  }

  void logNetwork({
    required NetworkRequestLogarteEntry request,
    required NetworkResponseLogarteEntry response,
  }) {
    try {
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
    } catch (_) {}
  }

  // TODO: add mono font

  Future<void> openConsole(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LogarteAuthScreen(this);
        },
      ),
    );
  }
}
