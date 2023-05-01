import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/logarte_type.dart';

abstract class LogarteEntry {
  final LogarteType type;
  final DateTime _date;

  LogarteEntry(this.type) : _date = DateTime.now();

  DateTime get date => _date;
  String get dateFormatted => '${date.hour.toString().padLeft(2, '0')}:${date.minute}:${date.second}';
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

// TODO: no need for extending?
class NetworkRequestLogarteEntry extends LogarteEntry {
  final String url;
  final String method;
  final Map<String, String>? headers;
  final Object? body;

  NetworkRequestLogarteEntry({
    required this.url,
    required this.method,
    required this.headers,
    this.body,
  }) : super(LogarteType.network);
}

class NetworkResponseLogarteEntry extends LogarteEntry {
  final int statusCode;
  final Map<String, String>? headers;
  final Object? body;

  NetworkResponseLogarteEntry({
    required this.statusCode,
    required this.headers,
    required this.body,
  }) : super(LogarteType.network);
}
