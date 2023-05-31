import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:logarte/src/console/logarte_auth_screen.dart';
import 'package:logarte/src/console/logarte_overlay.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/extensions/route_extensions.dart';
import 'package:logarte/src/models/logarte_entry.dart';
import 'package:logarte/src/models/navigation_action.dart';
import 'package:stack_trace/stack_trace.dart';

// TODO: add listener and refresher

class Logarte {
  final String? consolePassword;
  final Function(String data)? onShare;
  final List<LogarteEntry> logs = [];

  Logarte({
    this.consolePassword,
    this.onShare,
  });

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

  void error(
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

  void network({
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

  void navigation({
    required Route<dynamic>? route,
    required Route<dynamic>? previousRoute,
    required NavigationAction action,
  }) {
    try {
      if ([route.routeName, previousRoute.routeName]
          .any((e) => e?.contains('/logarte') == true)) {
        return;
      }

      log(
        '''
------------------ NAVIGATION -----------------
ROUTE: ${route.routeInfo}
PREVIOUS ROUTE: ${previousRoute.routeInfo}
------------------------------------------------

''',
        write: false,
      );

      logs.add(
        NavigatorLogarteEntry(
          route: route,
          previousRoute: previousRoute,
          action: action,
        ),
      );
    } catch (_) {}
  }

  void database({
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
        settings: const RouteSettings(name: '/logarte_auth'),
      ),
    );
  }
}
