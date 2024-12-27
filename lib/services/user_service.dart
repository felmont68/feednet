import 'package:feednet/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService with ChangeNotifier {
  late SharedPreferences prefs;

  Future<User> getUserData() async {
    prefs = await SharedPreferences.getInstance();
    final user = User();
    user.username = prefs.getString('username') ?? '';
    user.firstName = prefs.getString('first_name') ?? '';
    user.lastName = prefs.getString('last_name') ?? '';
    user.picture = prefs.getString('picture') ?? '';
    user.password = prefs.getString('password') ?? '';
    //user.status = prefs.getString('status') ?? '';
    return user;
  }

  Future<void> saveUserData(User user) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('username', user.username.toString());
    prefs.setString('first_name', user.firstName.toString());
    prefs.setString('last_name', user.lastName.toString());
    prefs.setString('picture', user.picture.toString());
    prefs.setString('status', user.status.toString());
  }

  Future<void> clearUserData() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('first_name');
    prefs.remove('last_name');
    prefs.remove('picture');
    prefs.remove('password');
    prefs.remove('status');
  }
}
