import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logarte/src/console/logarte_auth_screen.dart';
import 'package:logarte/src/console/logarte_overlay.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/extensions/route_extensions.dart';
import 'package:logarte/src/logger/logger.dart';
import 'package:logarte/src/logger/printers/pretty_printer.dart';
import 'package:logarte/src/models/logarte_entry.dart';
import 'package:logarte/src/models/navigation_action.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:logarte/src/logger/level.dart';

class Logarte {
  final String? password;
  final bool ignorePassword;
  final bool disableDebugConsoleLogs;
  final Function(String data)? onShare;
  final Function(BuildContext context)? onRocketLongPressed;
  final Function(BuildContext context)? onRocketDoubleTapped;
  late final Logger _logger;

  Logarte({
    this.password,
    this.ignorePassword = !kReleaseMode,
    this.onShare,
    this.onRocketLongPressed,
    this.onRocketDoubleTapped,
    this.disableDebugConsoleLogs = kReleaseMode,
  }) {
    _logger = Logger(
      printer: PrettyPrinter(
        lineLength: 100,
        methodCount: 0,
      ),
    );
  }

  final logs = ValueNotifier(<LogarteEntry>[]);
  void _add(LogarteEntry entry) => logs.value = [...logs.value, entry];

  void info(
    Object? message, {
    bool write = true,
    Trace? trace,
    Level level = Level.info,
  }) {
    _log(
      level,
      message,
      write: write,
      trace: trace ?? Trace.current(),
    );
  }

  void _log(
    Level level,
    Object? message, {
    bool write = true,
    Trace? trace,
  }) {
    // TODO: try and catch
    if (!disableDebugConsoleLogs){
      _logger.log(
        level,
        message.toString(),
      );
    }

    
    

    if (write) {
      _add(
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
    _log(
      Level.debug,
      'ERROR: $message\n\nTRACE: $stackTrace',
      write: write,
      trace: Trace.current(),
    );
  }

  void network({
    required NetworkRequestLogarteEntry request,
    required NetworkResponseLogarteEntry response,
    bool write = true,
  }) {
    try {
      _log(
        Level.network,
        '[${request.method}] URL: ${request.url}',
        write: write,
      );
      _log(
        Level.network,
        'HEADERS: ${request.headers.prettyJson}',
        write: write,
      );
      _log(
        Level.network,
        'BODY: ${request.body.prettyJson}',
        write: write,
      );
      _log(
        Level.network,
        'STATUS CODE: ${response.statusCode}',
        write: write,
      );
      _log(
        Level.network,
        'RESPONSE HEADERS: ${response.headers.prettyJson}',
        write: write,
      );
      _log(
        Level.network,
        'RESPONSE BODY: ${response.body.prettyJson}',
        write: write,
      );

      _add(
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

      // TODO: make it common logic
      final message = previousRoute != null
          ? action == NavigationAction.pop
              ? '$action from "${route.routeName}" to "${previousRoute.routeName}"'
              : '$action to "${route.routeName}"'
          : '$action to "${route.routeName}"';

      _log(
        Level.navigation,
        message,
        write: false,
      );

      _add(
        NavigatorLogarteEntry(
          route: route,
          previousRoute: previousRoute,
          action: action,
        ),
      );
    } catch (_) {}
  }

  void database({
    required String target,
    required Object? value,
    required String source,
  }) {
    try {
      _log(
        Level.info,
        '$target was written to database from $source with value: $value',
        write: false,
      );

      _add(
        DatabaseLogarteEntry(
          target: target,
          value: value,
          source: source,
        ),
      );
    } catch (_) {}
  }

  void attach({
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
