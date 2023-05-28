import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension LogarteStringXs on String {
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

  String get asReadableSize {
    final encoded = utf8.encode(this);
    return '${(encoded.length / 1024).toStringAsFixed(2)} kb';
  }
}
