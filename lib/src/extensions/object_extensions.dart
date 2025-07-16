import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

const String logartePrefix = 'logarte_';

extension SharedPreferencesExt on SharedPreferences {
  Set<String> get filteredKeys {
    return getKeys().where((e) => e.startsWith(logartePrefix)).toSet();
  }

  void setLogarteString(String key, String value) =>
      setString('$logartePrefix$key', value);

  void deleteLogarteString(String key,) =>
      remove('$logartePrefix$key');
}
