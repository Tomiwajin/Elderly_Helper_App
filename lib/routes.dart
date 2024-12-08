import 'package:flutter/material.dart';
import 'src/login_screen.dart';
import 'src/home_screen.dart';
import 'src/near_me_map_screen.dart';

class Routes {
  static const String loginScreen = '/login';
  static const String homeScreen = '/home';
  static const String mapScreen = '/map';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case mapScreen:
        return MaterialPageRoute(builder: (_) => const NearMeMapScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
