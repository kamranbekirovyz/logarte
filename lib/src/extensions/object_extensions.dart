import 'dart:convert';

import 'package:dio/dio.dart';

extension LogarteNullableStringXs on Object? {
  String get prettyJson {
    try {
      final source = this;

      if (source == null) {
        return 'null';
      }

      // Handle FormData
      if (source is FormData) {
        final Map<String, dynamic> data = {};

        // normal fields
        for (final field in source.fields) {
          try {
            data[field.key] = jsonDecode(field.value);
          } catch(_) {
            data[field.key] = field.value;
          }
        }

        // files
        for (final file in source.files) {
          final multipart = file.value;

          data[file.key] = multipart.filename ?? 'file';
        }

        return const JsonEncoder.withIndent('  ').convert(data);
      }

      // Handle String JSON
      if (source is String) {
        final decoded = jsonDecode(source);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      }

      // Handle Map/List
      return const JsonEncoder.withIndent('  ').convert(source);
    } catch (_) {
      return toString();
    }
  }
}
