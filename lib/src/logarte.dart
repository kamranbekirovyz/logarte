import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logarte/src/console/logarte_auth_screen.dart';
import 'package:logarte/src/console/logarte_overlay.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/extensions/route_extensions.dart';
import 'package:logarte/src/models/logarte_entry.dart';
import 'package:logarte/src/models/navigation_action.dart';

class Logarte {
  final String? password;
  final bool ignorePassword;
  final Function(String data)? onShare;
  final Function(String data)? onExport;
  final int logBufferLength;
  final Function(BuildContext context)? onRocketLongPressed;
  final Function(BuildContext context)? onRocketDoubleTapped;
  final bool disableDebugConsoleLogs;
  final Widget? customTab;

  Logarte({
    this.password,
    this.ignorePassword = !kReleaseMode,
    this.onShare,
    this.onExport,
    this.onRocketLongPressed,
    this.onRocketDoubleTapped,
    this.logBufferLength = 2500,
    this.disableDebugConsoleLogs = false,
    this.customTab,
  });

  final logs = ValueNotifier(<LogarteEntry>[]);
  void _add(LogarteEntry entry) {
    if (logs.value.length > logBufferLength) {
      logs.value.removeAt(0);
    }
    logs.value = [entry, ...logs.value];
  }

  @Deprecated('Use logarte.log() instead')
  void info(
    Object? message, {
    bool write = true,
    String? source,
  }) {
    _log(
      message,
      write: write,
      source: source,
    );
  }

  void log(
    Object? message, {
    bool write = true,
    StackTrace? stackTrace,
    String? source,
  }) {
    _log(
      message,
      write: write,
      stackTrace: stackTrace,
      source: source,
    );
  }

  @Deprecated('Use logarte.log() instead')
  void error(
    Object? message, {
    StackTrace? stackTrace,
    bool write = true,
  }) {
    _log(
      'ERROR: $message\n\nTRACE: $stackTrace',
      write: write,
    );
  }

  void network({
    required NetworkRequestLogarteEntry request,
    required NetworkResponseLogarteEntry response,
    bool write = true,
  }) {
    try {
      _log(
        '[${request.method}] URL: ${request.url}',
        write: write,
      );
      _log(
        'HEADERS: ${request.headers.prettyJson}',
        write: write,
      );
      _log(
        'BODY: ${request.body.prettyJson}',
        write: write,
      );
      _log(
        'STATUS CODE: ${response.statusCode}',
        write: write,
      );
      _log(
        'RESPONSE HEADERS: ${response.headers.prettyJson}',
        write: write,
      );
      _log(
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

  void _log(
    Object? message, {
    bool write = true,
    String? source,
    StackTrace? stackTrace,
  }) {
    if (!disableDebugConsoleLogs) {
      developer.log(
        message.toString(),
        name: 'logarte',
        stackTrace: stackTrace,
      );
    }

    if (write) {
      _add(
        PlainLogarteEntry(
          '${message.toString()}${stackTrace != null ? '\n\n$stackTrace' : ''}',
          source: source,
        ),
      );
    }
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

      _log(message, write: false);

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
        '$source: $target → $value',
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

  /// Check if LogarteOverlay is currently attached
  bool get isOverlayAttached => LogarteOverlay.isAttached;

  /// Detach the LogarteOverlay if it's currently attached
  void detachOverlay() {
    LogarteOverlay.detach();
  }

  Future<void> openConsole(BuildContext context) async {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => LogarteAuthScreen(this),
        settings: const RouteSettings(name: '/logarte_auth'),
      ),
    );
  }

  void clear() {
    logs.value = [];
  }
}
