import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:logarte/src/console/logarte_auth_screen.dart';
import 'package:logarte/src/console/logarte_overlay.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/models/logarte_entry.dart';
import 'package:stack_trace/stack_trace.dart';

// TODO: add navigation observer
// TODO: add internal theme with inherited widget
// TODO: add db inspector
// TODO: add listener and refresher

class Logarte {
  final String consolePassword;
  final Function(String data)? onShare;

  Logarte({
    required this.consolePassword,
    this.onShare,
  });

  final logs = <LogarteEntry>[];

  void log(
    Object? message, {
    bool write = true,
    Trace? trace,
  }) {
    // TODO: try and catch
    developer.log(message.toString());

    if (write) {
      logs.add(
        PlainLogarteEntry(
          message.toString(),
          trace: trace ?? Trace.current(),
        ),
      );
    }
  }

  void logError(
    Object? message, {
    StackTrace? stackTrace,
    bool write = true,
  }) {
    log(
      'ERROR: $message\n\nTRACE: $stackTrace',
      write: write,
      trace: Trace.current(),
    );
  }

  void logNetwork({
    required NetworkRequestLogarteEntry request,
    required NetworkResponseLogarteEntry response,
  }) {
    try {
      log(
        '''
------------------ NETWORK REQUEST -----------------
URL: [${request.method}] ${request.url}
REQUEST HEADERS: ${request.headers.prettyJson}
REQUEST BODY: ${request.body.prettyJson}
STATUS CODE: ${response.statusCode}
RESPONSE HEADERS: ${response.headers.prettyJson}
RESPONSE BODY: ${response.body.prettyJson}
----------------------------------------------------
''',
        write: false,
      );

      logs.add(
        NetworkLogarteEntry(
          request: request,
          response: response,
        ),
      );
    } catch (_) {}
  }

  void logDatabaseWrite({
    required String key,
    required String? value,
    required String source,
  }) {
    try {
      log(
        '$key was written to database from $source with value: $value',
        write: false,
      );

      logs.add(
        DatabaseLogarteEntry(
          key: key,
          value: value,
          source: source,
        ),
      );
    } catch (_) {}
  }

  void attachBackDoorButtonOverlay({
    required BuildContext context,
    required bool visible,
  }) async {
    if (visible) {
      return LogarteOverlay.attach(
        context: context,
        instance: this,
      );
    }
  }

  Future<void> openConsole(BuildContext context) async {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => LogarteAuthScreen(this),
      ),
    );
  }
}
