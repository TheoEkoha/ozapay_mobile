import 'package:ozapay/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  final SharedPreferences prefs;

  PrefsService(this.prefs);

  /// Access Token
  String? getAccessToken() => prefs.getString(kAccessToken);

  Future<bool> setAccessToken(String token) =>
      prefs.setString(kAccessToken, token);

  Future<bool> removeAccessToken() => prefs.remove(kAccessToken);

  /// User id
  int? getUserId() => prefs.getInt(kUserId);

  Future<bool> setUserId(int userId) => prefs.setInt(kUserId, userId);

  Future<bool> removeUserId() => prefs.remove(kUserId);

  /// Hide balance
  Future<bool> setHideBalance(bool hide) => prefs.setBool(kHideBalance, hide);

  bool? getHideBalance() => prefs.getBool(kHideBalance);
}
