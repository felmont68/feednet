import 'package:feednet/screens/login_screen.dart';
import 'package:feednet/screens/profile_screen.dart';
import 'package:feednet/screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => RegisterScreen(),
      home: (context) => const HomeScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}
