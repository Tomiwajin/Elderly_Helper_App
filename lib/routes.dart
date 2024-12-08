import 'package:flutter/material.dart';
import 'package:elderly_helper/src/home_screen.dart';
import 'package:elderly_helper/src/emergency_help_screen.dart';
import 'package:elderly_helper/src/non_emergency_help_screen.dart';
import 'package:elderly_helper/src/near_me_map_screen.dart';
import 'package:elderly_helper/src/request_meal_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/emergency':
        return MaterialPageRoute(builder: (_) => const EmergencyHelpScreen());
      case '/non_emergency':
        return MaterialPageRoute(builder: (_) => const NonEmergencyHelpScreen());
      case '/request_meal':
        return MaterialPageRoute(builder: (_) => const RequestMealScreen());
      case '/near_me_map':
        return MaterialPageRoute(builder: (_) => const NearMeMapScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
