import 'dart:convert';

extension LogarteNullableStringXs on Object? {
  String get prettyJson {
    try {
      final source = this;

      return const JsonEncoder.withIndent('  ').convert(
        source is String ? jsonDecode(source) : this,
      );
    } catch (_) {
      return toString();
    }
  }
}
