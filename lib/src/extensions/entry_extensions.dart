import 'package:logarte/logarte.dart';

extension LogarteNetworkEntryXs on NetworkLogarteEntry {
  String get asReadableDuration {
    return '${response.receivedAt!.difference(request.sentAt!).inMilliseconds} ms';
  }
}
