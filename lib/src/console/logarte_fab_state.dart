import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class LogarteFabState {
  LogarteFabState._internal();

  static final LogarteFabState _instance = LogarteFabState._internal();

  static LogarteFabState get instance => _instance;

  final ValueNotifier<bool> _isOpened = ValueNotifier(false);

  /// Expose as ValueListenable for external listeners
  ValueListenable<bool> get fabStateListener => _isOpened;

  /// Current state
  bool get isOpened => _isOpened.value;

  /// Open the FAB (set true)
  void open() {
    _deferUpdate(true);
  }

  /// Close the FAB (set false)
  void close() {
    _deferUpdate(false);
  }

  void _deferUpdate(bool value) {
    // Safely defer updates after the current frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _isOpened.value = value;
    });
  }
}