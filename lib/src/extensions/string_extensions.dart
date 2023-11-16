import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension LogarteStringXs on String {
  Future<void> copyToClipboard(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          content: Center(
            child: Text(
              'Copied',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

    HapticFeedback.lightImpact();

    return Clipboard.setData(ClipboardData(text: this));
  }

  String get asReadableSize {
    final encoded = utf8.encode(this);
    return '${(encoded.length / 1024).toStringAsFixed(2)} kb';
  }
}
