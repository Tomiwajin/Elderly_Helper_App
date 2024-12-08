import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elderly_helper/src/home_screen.dart';
import 'non_emergency_help_screen.dart';
import 'request_meal_screen.dart';
import 'calendar_screen.dart';
import 'picture_taking_screen.dart';
import 'near_me_map_screen.dart';
import 'package:elderly_helper/battery_status_widget.dart'; // Import the Battery Status Widget

class EmergencyHelpScreen extends StatefulWidget {
  const EmergencyHelpScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyHelpScreen> createState() => _EmergencyHelpScreenState();
}

class _EmergencyHelpScreenState extends State<EmergencyHelpScreen> {
  int _selectedIndex = 0; // Track the selected index of BottomNavigationBar

  // Define screens for each tab
  final List<Widget> _screens = [
    const EmergencyHelpScreenContent(), // Emergency Help screen content
    const BrowseScreen(), // Placeholder for Browse screen
    const TextToSpeechScreen(), // Placeholder for Text-to-Speech screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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
            const PopupMenuItem(value: 'non_emergency', child: Text('Non-Emergency Help')),
            const PopupMenuItem(value: 'request_meal', child: Text('Request Meal')),
            const PopupMenuItem(value: 'calendar', child: Text('Calendar')),
            const PopupMenuItem(value: 'take_picture', child: Text('Take Picture')),
            const PopupMenuItem(value: 'near_me', child: Text('Near Me Map')),
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
              case 'calendar':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                );
                break;
              case 'take_picture':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PictureTakingScreen()),
                );
                break;
              case 'near_me':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const NearMeMapScreen()),
                );
                break;
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Help',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              user?.email ?? 'Guest',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          const BatteryStatusWidget(), // Add the Battery Status Widget here
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
          _buildNavigationMenu(context),
        ],
      ),
      body: _screens[_selectedIndex], // Dynamically load the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Update index on tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
            label: 'Text-to-Speech',
          ),
        ],
      ),
    );
  }
}

class EmergencyHelpScreenContent extends StatelessWidget {
  const EmergencyHelpScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Emergency Help Content Here',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

// Placeholder widget for Browse screen
class BrowseScreen extends StatelessWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Browse Screen Content'));
  }
}

// Placeholder widget for Text-to-Speech screen
class TextToSpeechScreen extends StatelessWidget {
  const TextToSpeechScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Text-to-Speech Screen Content'));
  }
}
