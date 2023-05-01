import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension LogarteStringExtensions on String {
  Future<void> copyToClipboard(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Copied 🖨️',
            textAlign: TextAlign.center,
          ),
        ),
      );

    return Clipboard.setData(ClipboardData(text: this));
  }
}
