import 'package:logarte/logarte.dart';

extension LogarteNetworkEntryXs on NetworkLogarteEntry {
  String get asReadableDuration {
    if (request.sentAt == null || response.receivedAt == null) {
      return 'N/A ms';
    }

    return '${response.receivedAt!.difference(request.sentAt!).inMilliseconds} ms';
  }

  String get extractQueryParams {
    Uri uri = Uri.parse(request.url);
    final params = uri.queryParameters;
    StringBuffer formatted = StringBuffer();
    params.forEach((key, value) {
      formatted.write("$key = $value");
    });
    return formatted.toString();
  }
}
