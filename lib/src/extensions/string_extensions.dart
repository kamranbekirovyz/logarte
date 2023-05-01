import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension LogarteStringExtensions on String {
  Future<void> copyToClipboard(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Copied 🖨️',
            textAlign: TextAlign.center,
          ),
        ),
      );

    return Clipboard.setData(ClipboardData(text: this));
  }

  String get removeHost {
    final uri = Uri.parse(this);

    return uri.path;
  }
}
