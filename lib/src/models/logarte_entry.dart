import 'package:flutter/widgets.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/models/logarte_network_filter.dart';
import 'package:logarte/src/models/logarte_search_filter.dart';
import 'package:logarte/src/models/logarte_type.dart';
import 'package:logarte/src/models/navigation_action.dart';

abstract class LogarteEntry {
  final LogarteType type;
  final DateTime _date;

  LogarteEntry(this.type) : _date = DateTime.now();

  DateTime get date => _date;
  String get timeFormatted =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second}';

  List<String> getContents(LogarteSearchFilter? filter);
}

class PlainLogarteEntry extends LogarteEntry {
  final String message;
  final String? source;

  PlainLogarteEntry(
    this.message, {
    this.source,
  }) : super(LogarteType.plain);

  @override
  List<String> getContents(LogarteSearchFilter? filter) => [
        message,
        if (source != null) source!,
      ];
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
  List<String> getContents(LogarteSearchFilter? filter) => [
        if (route?.settings.name != null) route!.settings.name!,
        if (route?.settings.arguments != null)
          route!.settings.arguments.toString(),
        action.name,
        if (previousRoute != null && previousRoute!.settings.name != null)
          previousRoute!.settings.name!,
        if (previousRoute != null && previousRoute!.settings.arguments != null)
          previousRoute!.settings.arguments.toString(),
      ];
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
  List<String> getContents(LogarteSearchFilter? filter) => [
        target,
        if (value != null) value.toString(),
        source,
      ];
}

class NetworkLogarteEntry extends LogarteEntry {
  final NetworkRequestLogarteEntry request;
  final NetworkResponseLogarteEntry response;

  NetworkLogarteEntry({
    required this.request,
    required this.response,
  }) : super(LogarteType.network);

  @override
  List<String> getContents(LogarteSearchFilter? filter) {
    final searchFilter = filter?.network ?? const LogarteNetworkSearchFilter();
    return [
      searchFilter.url ? request.url : null,
      searchFilter.method ? request.method : null,
      searchFilter.header ? request.headers?.toString() : null,
      searchFilter.body ? request.body?.toString() : null,
      searchFilter.time ? request.sentAt?.toString() : null,
      searchFilter.statusCode ? response.statusCode?.toString() : null,
      searchFilter.header ? response.headers?.toString() : null,
      searchFilter.body ? response.body?.toString() : null,
      searchFilter.time ? response.receivedAt?.toString() : null,
    ].whereType<String>().toList();
  }

  @override
  String toString() {
    return '''[${request.method}] ${request.url}

-- REQUEST --
HEADERS: ${request.headers.prettyJson}

BODY: ${request.body.prettyJson}

-- RESPONSE --
STATUS CODE: ${response.statusCode}

HEADERS: ${response.headers.prettyJson}

BODY: ${response.body.prettyJson}
''';
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
