import 'package:logarte/logarte.dart';

extension LogarteNetworkEntryXs on NetworkLogarteEntry {
  String get asReadableDuration {
    if (request.sentAt == null || response.receivedAt == null) {
      return 'N/A ms';
    }

    return '${response.receivedAt!.difference(request.sentAt!).inMilliseconds} ms';
  }
}
