import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_button.dart';

/// Owns the floating button's lifecycle for a [Logarte] instance.
class LogarteButtonController {
  LogarteButtonController(this._logarte);

  final Logarte _logarte;

  /// Whether the button is shown, or about to be on the next frame.
  final ValueNotifier<bool> isVisible = ValueNotifier(false);

  /// Whether the console is open, which switches the button to its close state.
  final ValueNotifier<bool> isConsoleOpen = ValueNotifier(false);

  OverlayEntry? _entry;
  OverlayState? _overlay;
  bool _isInserted = false;

  void show(BuildContext context) {
    if (_entry != null && (_overlay?.mounted ?? false)) return;
    hide();

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    final entry = OverlayEntry(builder: (_) => LogarteButton(_logarte));
    _entry = entry;
    _overlay = overlay;
    isVisible.value = true;

    // Inserting during a build throws, so wait for the frame to finish.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!identical(_entry, entry)) return;
      if (!overlay.mounted) return hide();

      overlay.insert(entry);
      _isInserted = true;
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  void hide() {
    final entry = _entry;
    final wasInserted = _isInserted;

    _entry = null;
    _overlay = null;
    _isInserted = false;
    isVisible.value = false;

    if (wasInserted) entry?.remove();
    entry?.dispose();
  }

  /// Called from screen lifecycle methods, so the update waits for the frame.
  void setConsoleOpen(bool isOpen) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      isConsoleOpen.value = isOpen;
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }
}
