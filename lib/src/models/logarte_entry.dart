import 'package:flutter/widgets.dart';
import 'package:logarte/src/extensions/entry_extensions.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/extensions/route_extensions.dart';
import 'package:logarte/src/extensions/string_extensions.dart';
import 'package:logarte/src/models/logarte_type.dart';
import 'package:logarte/src/models/navigation_action.dart';

abstract class LogarteEntry {
  final LogarteType type;
  final DateTime _date;

  LogarteEntry(this.type) : _date = DateTime.now();

  DateTime get date => _date;
  String get timeFormatted =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second}';

  List<String> get contents;
}

class PlainLogarteEntry extends LogarteEntry {
  final String message;
  final String? source;

  PlainLogarteEntry(
    this.message, {
    this.source,
  }) : super(LogarteType.plain);

  @override
  List<String> get contents => [
        message,
        if (source != null) source!,
      ];

  @override
  String toString() {
    return '[LOG]${source != null ? ' $source' : ''}\n$message';
  }
}

class NavigatorLogarteEntry extends LogarteEntry {
  final Route<dynamic>? route;
  final Route<dynamic>? previousRoute;
  final NavigationAction action;

  NavigatorLogarteEntry({
    required this.route,
    required this.previousRoute,
    required this.action,
  }) : super(LogarteType.navigation);

  @override
  List<String> get contents => [
        if (route?.settings.name != null) route!.settings.name!,
        if (route?.settings.arguments != null)
          route!.settings.arguments.toString(),
        action.name,
        if (previousRoute != null && previousRoute!.settings.name != null)
          previousRoute!.settings.name!,
        if (previousRoute != null && previousRoute!.settings.arguments != null)
          previousRoute!.settings.arguments.toString(),
      ];

  @override
  String toString() {
    final routeName = route?.routeName ?? 'unknown';
    final previousRouteName = previousRoute?.routeName;

    String actionText;
    if (previousRoute != null && action == NavigationAction.pop) {
      actionText = '$action from "$routeName" to "$previousRouteName"';
    } else {
      actionText = '$action to "$routeName"';
    }

    final buffer = StringBuffer('[NAVIGATION]\n$actionText');

    if (route?.settings.arguments != null) {
      buffer.write('\nARGS: ${route!.settings.arguments}');
    }

    return buffer.toString();
  }
}

class DatabaseLogarteEntry extends LogarteEntry {
  final String target;
  final Object? value;
  final String source;

  DatabaseLogarteEntry({
    required this.target,
    required this.value,
    required this.source,
  }) : super(LogarteType.database);

  @override
  List<String> get contents => [
        target,
        if (value != null) value.toString(),
        source,
      ];

  @override
  String toString() {
    return '[DATABASE] $source\nTARGET: $target\nVALUE: ${value?.toString() ?? 'null'}';
  }
}

class NetworkLogarteEntry extends LogarteEntry {
  final NetworkRequestLogarteEntry request;
  final NetworkResponseLogarteEntry response;

  NetworkLogarteEntry({
    required this.request,
    required this.response,
  }) : super(LogarteType.network);

  @override
  List<String> get contents => [
        request.url,
        request.method,
        if (request.headers != null) request.headers!.toString(),
        if (request.body != null) request.body.toString(),
        if (request.sentAt != null) request.sentAt.toString(),
        if (response.statusCode != null) response.statusCode.toString(),
        if (response.headers != null) response.headers!.toString(),
        if (response.body != null) response.body.toString(),
        if (response.receivedAt != null) response.receivedAt.toString(),
      ];

  @override
  String toString() {
    final duration = asReadableDuration;
    final size = response.body?.toString().asReadableSize ?? '0B';
    final statusText = response.statusCode != null
        ? '${response.statusCode} ${_getStatusText(response.statusCode!)}'
        : 'No Response';

    return '''[NETWORK] ${request.method} ${request.url}
STATUS: $statusText • $duration • $size
HEADERS: ${request.headers.prettyJson}
BODY: ${request.body.prettyJson}
RESPONSE: ${response.body.prettyJson}''';
  }

  String _getStatusText(int code) {
    if (code >= 200 && code < 300) return 'OK';
    if (code >= 400 && code < 500) return 'Client Error';
    if (code >= 500) return 'Server Error';
    return 'Unknown';
  }
}

class NetworkRequestLogarteEntry {
  final String url;
  final String method;
  final Map<String, dynamic>? headers;
  final Object? body;
  final DateTime? sentAt;

  const NetworkRequestLogarteEntry({
    required this.url,
    required this.method,
    required this.headers,
    this.body,
    this.sentAt,
  });
}

class NetworkResponseLogarteEntry {
  final int? statusCode;
  final Map<String, String>? headers;
  final Object? body;
  final DateTime? receivedAt;

  NetworkResponseLogarteEntry({
    required this.statusCode,
    required this.headers,
    required this.body,
    this.receivedAt,
  });
}
