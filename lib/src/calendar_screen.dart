import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'emergency_help_screen.dart';
import 'non_emergency_help_screen.dart';
import 'request_meal_screen.dart';
import 'near_me_map_screen.dart';
import 'package:elderly_helper/battery_status_widget.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Widget _buildNavigationMenu(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: 'Navigate',
      onPressed: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(100, 100, 0, 0),
          items: [
            const PopupMenuItem(value: 'home', child: Text('Home')),
            const PopupMenuItem(value: 'emergency', child: Text('Emergency Help')),
            const PopupMenuItem(value: 'non_emergency', child: Text('Non-Emergency Help')),
            const PopupMenuItem(value: 'request_meal', child: Text('Request Meal')),
            const PopupMenuItem(value: 'near_me_map', child: Text('Near Me Map')),
          ],
        ).then((value) {
          if (value != null) {
            switch (value) {
              case 'home':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
                break;
              case 'emergency':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const EmergencyHelpScreen()),
                );
                break;
              case 'non_emergency':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const NonEmergencyHelpScreen()),
                );
                break;
              case 'request_meal':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RequestMealScreen()),
                );
                break;
              case 'near_me_map':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const NearMeMapScreen()),
                );
            }
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: _buildNavigationMenu(context),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              user?.email ?? 'Not logged in',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          const BatteryStatusWidget(), // Battery status now before the logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Calendar Content Here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
