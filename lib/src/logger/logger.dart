import 'package:flutter/material.dart';
import 'package:logarte/src/logger/filters/development_filter.dart';
import 'package:logarte/src/logger/log_filter.dart';
import 'package:logarte/src/logger/log_output.dart';
import 'package:logarte/src/logger/log_printer.dart';
import 'package:logarte/src/logger/outputs/console_output.dart';
import 'package:logarte/src/logger/printers/pretty_printer.dart';
import 'package:logarte/src/logger/level.dart';



class LogEvent {
  final Level level;
  final dynamic message;
  final Object? error;
  final StackTrace? stackTrace;

  /// Time when this log was created.
  final DateTime time;

  LogEvent(
    this.level,
    this.message, {
    DateTime? time,
    this.error,
    this.stackTrace,
  }) : time = time ?? DateTime.now();
}

class OutputEvent {
  final List<String> lines;
  final LogEvent origin;

  Level get level => origin.level;

  OutputEvent(this.origin, this.lines);
}

typedef LogCallback = void Function(LogEvent event);

typedef OutputCallback = void Function(OutputEvent event);

/// Use instances of logger to send log messages to the [LogPrinter].
class Logger {
  /// The current logging level of the app.
  ///
  /// All logs with levels below this level will be omitted.
  static Level level = Level.trace;

  /// The current default implementation of log filter.
  static LogFilter Function() defaultFilter = () => DevelopmentFilter();

  /// The current default implementation of log printer.
  static LogPrinter Function() defaultPrinter = () => PrettyPrinter();

  /// The current default implementation of log output.
  static LogOutput Function() defaultOutput = () => ConsoleOutput();

  static final Set<LogCallback> _logCallbacks = {};

  static final Set<OutputCallback> _outputCallbacks = {};

  final LogFilter _filter;
  final LogPrinter _printer;
  final LogOutput _output;
  bool _active = true;

  /// Create a new instance of Logger.
  ///
  /// You can provide a custom [printer], [filter] and [output]. Otherwise the
  /// defaults: [PrettyPrinter], [DevelopmentFilter] and [ConsoleOutput] will be
  /// used.
  Logger({
    LogFilter? filter,
    LogPrinter? printer,
    LogOutput? output,
    Level? level,
  })  : _filter = filter ?? defaultFilter(),
        _printer = printer ?? defaultPrinter(),
        _output = output ?? defaultOutput() {
    _filter.init();
    _filter.level = level ?? Logger.level;
    _printer.init();
    _output.init();
  }

  /// Log a message with [level].
  void log(
    Level level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_active) {
      throw ArgumentError('Logger has already been closed.');
    } else if (error != null && error is StackTrace) {
      throw ArgumentError('Error parameter cannot take a StackTrace!');
    } else if (level == Level.all) {
      throw ArgumentError('Log events cannot have Level.all');
    } else if (level == Level.off) {
      throw ArgumentError('Log events cannot have Level.off');
    }

    var logEvent = LogEvent(
      level,
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
    for (var callback in _logCallbacks) {
      callback(logEvent);
    }

    if (_filter.shouldLog(logEvent)) {
      var output = _printer.log(logEvent);

      if (output.isNotEmpty) {
        var outputEvent = OutputEvent(logEvent, output);
        // Issues with log output should NOT influence
        // the main software behavior.
        try {
          for (var callback in _outputCallbacks) {
            callback(outputEvent);
          }
          _output.output(outputEvent);
        } catch (e, s) {
          debugPrint(e.toString());
          debugPrint(s.toString());
        }
      }
    }
  }

  bool isClosed() {
    return !_active;
  }

  /// Closes the logger and releases all resources.
  Future<void> close() async {
    _active = false;
    await _filter.destroy();
    await _printer.destroy();
    await _output.destroy();
  }

  /// Register a [LogCallback] which is called for each new [LogEvent].
  static void addLogListener(LogCallback callback) {
    _logCallbacks.add(callback);
  }

  /// Removes a [LogCallback] which was previously registered.
  ///
  /// Returns whether the callback was successfully removed.
  static bool removeLogListener(LogCallback callback) {
    return _logCallbacks.remove(callback);
  }

  /// Register an [OutputCallback] which is called for each new [OutputEvent].
  static void addOutputListener(OutputCallback callback) {
    _outputCallbacks.add(callback);
  }

  /// Removes a [OutputCallback] which was previously registered.
  ///
  /// Returns whether the callback was successfully removed.
  static void removeOutputListener(OutputCallback callback) {
    _outputCallbacks.remove(callback);
  }
}
