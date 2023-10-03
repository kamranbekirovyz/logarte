import 'package:logarte/src/logger/log_filter.dart';
import 'package:logarte/src/logger/logger.dart';

/// Prints all logs with `level >= Logger.level` even in production.
class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.value >= level!.value;
  }
}
