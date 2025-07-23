import 'package:logarte/src/models/logarte_network_filter.dart';

class LogarteSearchFilter {
  final LogarteNetworkSearchFilter network;

  const LogarteSearchFilter({
    this.network = const LogarteNetworkSearchFilter(),
  });

  LogarteSearchFilter copyWith({
    LogarteNetworkSearchFilter? network,
  }) {
    return LogarteSearchFilter(
      network: network ?? this.network,
    );
  }
}
