import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'emergency_help_screen.dart';
import 'non_emergency_help_screen.dart';
import 'request_meal_screen.dart';
import 'calendar_screen.dart';
import 'picture_taking_screen.dart';
import 'near_me_map_screen.dart';
import 'package:elderly_helper/battery_status_widget.dart'; // Import your battery status widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index of BottomNavigationBar

  // Define screens for each tab
  final List<Widget> _screens = [
    const HomeScreenContent(), // Existing Home screen content
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Get user info

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              user?.email ?? 'Guest',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          const BatteryStatusWidget(), // Add Battery Status Widget
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _screens[_selectedIndex], // Dynamically load the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Update index on tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: [
          _buildFeatureCard(
            context,
            icon: Icons.warning,
            title: 'Emergency Help',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmergencyHelpScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.healing,
            title: 'Non-Emergency Help',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NonEmergencyHelpScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.restaurant_menu,
            title: 'Request Meal',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RequestMealScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.calendar_today,
            title: 'Calendar',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalendarScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.camera_alt,
            title: 'Take Picture',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PictureTakingScreen()),
            ),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.map,
            title: 'Near Me Map',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NearMeMapScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
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
