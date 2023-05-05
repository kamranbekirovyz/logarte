import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/models/logarte_type.dart';

abstract class LogarteEntry {
  final LogarteType type;
  final DateTime _date;

  LogarteEntry(this.type) : _date = DateTime.now();

  DateTime get date => _date;
  String get timeFormatted =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second}';
}

class PlainLogarteEntry extends LogarteEntry {
  final String message;

  PlainLogarteEntry(this.message) : super(LogarteType.plain);
}

class DatabaseLogarteEntry extends LogarteEntry {
  final String key;
  final String? value;
  final String source;

  DatabaseLogarteEntry({
    required this.key,
    required this.value,
    required this.source,
  }) : super(LogarteType.database);
}

class NetworkLogarteEntry extends LogarteEntry {
  final NetworkRequestLogarteEntry request;
  final NetworkResponseLogarteEntry response;

  NetworkLogarteEntry({
    required this.request,
    required this.response,
  }) : super(LogarteType.network);

  @override
  String toString() {
    return '''[${request.method}] ${request.url}

-- REQUEST --
HEADERS: ${response.headers.prettyJson}

BODY: ${response.body.prettyJson}

-- RESPONSE --
STATUS CODE: [${response.statusCode}]

HEADERS: ${response.headers.prettyJson}

BODY: ${response.body.prettyJson}
''';
  }
}

class NetworkRequestLogarteEntry {
  final String url;
  final String method;
  final Map<String, String>? headers;
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
  final int statusCode;
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
