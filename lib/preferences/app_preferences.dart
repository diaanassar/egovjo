import 'dart:convert';

import 'package:complaints_app/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();
  late SharedPreferences _sharedPreferences;

  factory AppPreferences() {
    return _instance;
  }

  AppPreferences._internal();

  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Future<void> showBoarding() async {
  //   await _sharedPreferences.setBool('showBoarding', true);
  // }

  Future<void> stateCheckFcm(bool state) async {
    await _sharedPreferences.setBool('getFcm', state);
  }

  Future<void> saveLogin({required Users users, required String path}) async {
    await _sharedPreferences.setBool('logged_in', true);
    await _sharedPreferences.setString('path', path);
    await _sharedPreferences.setString('name', users.name);
    await _sharedPreferences.setString('email', users.email);
    await _sharedPreferences.setString('password', users.password);
    await _sharedPreferences.setString('mobile', users.mobile);
    await _sharedPreferences.setString('fcm', users.fcm);
    await _sharedPreferences.setString('levelUser', users.levelUser);
    await _sharedPreferences.setBool('isSuspend', users.isSuspend);
  }

  Future<void> saveAndChangePassword({required String password}) async {
    await _sharedPreferences.setString('password', password);
  }

  Future<void> saveArrayMinistry({required List<String> ministryList}) async {
    await _sharedPreferences.remove('arrayMinistry');
    await _sharedPreferences.setStringList('arrayMinistry', ministryList);
  }

  List<String> get getArrayMinistry => _sharedPreferences.getStringList('arrayMinistry') ?? ['Choose the Ministry'];

  Future<void> saveFcm({required String fcm}) async {
    await _sharedPreferences.setString('fcm', fcm);
  }

  Future<bool> logout() async {
    await _sharedPreferences.remove('logged_in');
    await _sharedPreferences.remove('path');
    await _sharedPreferences.remove('name');
    await _sharedPreferences.remove('email');
    await _sharedPreferences.remove('password');
    await _sharedPreferences.remove('mobile');
    await _sharedPreferences.remove('levelUser');
    await _sharedPreferences.remove('fcm');
    await _sharedPreferences.remove('getFcm');
    await _sharedPreferences.remove('isSuspend');
    await _sharedPreferences.remove('arrayMinistry');
    return true;
  }

  bool get checkGetFcm => _sharedPreferences.getBool('getFcm') ?? false;

  bool get loggedIn => _sharedPreferences.getBool('logged_in') ?? false;

  Users get getUserData {
    return Users.data(
      path: _sharedPreferences.getString('path') ?? '',
      name: _sharedPreferences.getString('name') ?? '',
      email: _sharedPreferences.getString('email') ?? '',
      password: _sharedPreferences.getString('password') ?? '',
      mobile: _sharedPreferences.getString('mobile') ?? '',
      levelUser: _sharedPreferences.getString('levelUser') ?? '',
      fcm: _sharedPreferences.getString('fcm') ?? '',
      isSuspend: _sharedPreferences.getBool('isVerified') ?? false,
    );
  }
}
