import 'package:hive_flutter/hive_flutter.dart';

import 'app_constants.dart';

class LocalStorage {
  LocalStorage._privateConstructor();
  static final LocalStorage _instance = LocalStorage._privateConstructor();

  static LocalStorage get instance {
    return _instance;
  }

  static final box = Hive.box(AppConstants.configName);

  void setValue(String key, dynamic value) {
    box.put(key, value);
  }

  dynamic getValue(String key) {
    return box.get(key);
  }

  void deleteValue(String key) {
    box.delete(key);
  }
}
