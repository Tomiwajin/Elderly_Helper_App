import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elderly_helper/src/home_screen.dart';
import 'emergency_help_screen.dart';
import 'non_emergency_help_screen.dart';
import 'near_me_map_screen.dart';
import 'package:elderly_helper/battery_status_widget.dart';
import 'breakfast_list_screen.dart'; // Import the BreakfastListScreen

class RequestMealScreen extends StatefulWidget {
  const RequestMealScreen({super.key});

  @override
  State<RequestMealScreen> createState() => _RequestMealScreenState();
}

class _RequestMealScreenState extends State<RequestMealScreen> {
  int _selectedIndex = 0; // Track the selected index for BottomNavigationBar

  // Define screens for each tab
  final List<Widget> _screens = [
    const RequestMealScreenContent(), // Request Meal content
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
            const PopupMenuItem(value: 'emergency', child: Text('Emergency Help')),
            const PopupMenuItem(value: 'non_emergency', child: Text('Non-Emergency Help')),
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
              case 'near_me_map':
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
              'Request Meal',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              user?.email ?? 'Guest',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          const BatteryStatusWidget(), // Added consistent Battery Status Widget
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
            icon: Icon(Icons.fastfood),
            label: 'Request Meal',
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

class RequestMealScreenContent extends StatelessWidget {
  const RequestMealScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Breakfast icon with navigation functionality
          GestureDetector(
            onTap: () {
              // Navigate to the Breakfast List screen when the icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BreakfastListScreen()),
              );
            },
            child: const Column(
              children: [
                Icon(
                  Icons.fastfood,
                  size: 80.0,
                  color: Colors.orange,
                ),
                Text('Breakfast', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Lunch icon without functionality (only labeled)
          const Column(
            children: [
              Icon(
                Icons.local_dining,
                size: 80.0,
                color: Colors.green,
              ),
              Text('Lunch', style: TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          
          // Dinner icon without functionality (only labeled)
          const Column(
            children: [
              Icon(
                Icons.dinner_dining,
                size: 80.0,
                color: Colors.red,
              ),
              Text('Dinner', style: TextStyle(fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }
}

// Placeholder widget for Browse screen
class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Browse Screen Content'));
  }
}

// Placeholder widget for Text-to-Speech screen
class TextToSpeechScreen extends StatelessWidget {
  const TextToSpeechScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Text-to-Speech Screen Content'));
  }
}
