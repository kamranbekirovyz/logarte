import 'dart:developer';

import 'package:logarte/src/logger/log_output.dart';
import 'package:logarte/src/logger/logger.dart';

/// Default implementation of [LogOutput].
///
/// It sends everything to the system console.
class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(log);
  }
}
