// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

const String keyUuid = "uuid_current_user";

class SharedPref {
  static void saveUuid(String uuid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(keyUuid, uuid);
  }

  static Future<String> getUuid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? uuidUser = preferences.getString(keyUuid);
    // print("idUser depuis sharedPref " + uuidUser!);
    return uuidUser!;
  }

  static void removeUuid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(keyUuid);
  }
}
