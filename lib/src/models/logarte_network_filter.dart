class LogarteNetworkSearchFilter {
  final bool statusCode;
  final bool method;
  final bool url;
  final bool header;
  final bool body;
  final bool time;

  const LogarteNetworkSearchFilter({
    this.statusCode = true,
    this.method = true,
    this.url = true,
    this.header = true,
    this.body = true,
    this.time = true,
  });

  LogarteNetworkSearchFilter copyWith({
    bool? statusCode,
    bool? method,
    bool? url,
    bool? header,
    bool? body,
    bool? time,
  }) {
    return LogarteNetworkSearchFilter(
      statusCode: statusCode ?? this.statusCode,
      method: method ?? this.method,
      url: url ?? this.url,
      header: header ?? this.header,
      body: body ?? this.body,
      time: time ?? this.time,
    );
  }
}
