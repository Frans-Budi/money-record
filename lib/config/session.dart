import 'dart:convert';

import 'package:get/get.dart';
import 'package:money_record/data/model/user.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<bool> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> mapUser = user.toJson();
    String stringUser = jsonEncode(mapUser);
    bool success = await pref.setString("user", stringUser);

    if (success) {
      //set user state in controller
      final cUser = Get.put(CUser());
      cUser.setData(user);
    }

    return success;
  }

  static Future<User> getUser() async {
    User user = User();
    final pref = await SharedPreferences.getInstance();
    String? stringUser = pref.getString("user");
    if (stringUser != null) {
      Map<String, dynamic> mapUser = jsonDecode(stringUser);
      user = User.fromJson(mapUser);
    }
    //set user state in controller
    final cUser = Get.put(CUser());
    cUser.setData(user);

    return user;
  }

  static Future<bool> clearUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');

    //set user state in controller
    final cUser = Get.put(CUser());
    cUser.setData(User());

    return success;
  }
}
