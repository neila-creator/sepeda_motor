import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  static const String _boxName = 'authBox';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static bool isLoggedIn() {
    final box = Hive.box(_boxName);
    return box.get('isLogin', defaultValue: false);
  }

  static String getRole() {
    final box = Hive.box(_boxName);
    return box.get('role', defaultValue: '');
  }

  static Future<void> login(String role) async {
    final box = Hive.box(_boxName);
    await box.put('isLogin', true);
    await box.put('role', role);
  }

  static Future<void> logout() async {
    final box = Hive.box(_boxName);
    await box.clear();
  }
}
