class LogarteNetworkFilter {
  final bool statusCode;
  final bool method;
  final bool host;
  final bool path;
  final bool body;

  const LogarteNetworkFilter({
    this.statusCode = true,
    this.method = true,
    this.host = true,
    this.path = true,
    this.body = true,
  });

  LogarteNetworkFilter copyWith({
    bool? statusCode,
    bool? method,
    bool? host,
    bool? path,
    bool? body,
  }) {
    return LogarteNetworkFilter(
      statusCode: statusCode ?? this.statusCode,
      method: method ?? this.method,
      host: host ?? this.host,
      path: path ?? this.path,
      body: body ?? this.body,
    );
  }
}
