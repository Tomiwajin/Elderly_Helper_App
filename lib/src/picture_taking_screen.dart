import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elderly_helper/src/home_screen.dart';
import 'emergency_help_screen.dart';
import 'non_emergency_help_screen.dart';
import 'near_me_map_screen.dart';
import 'package:elderly_helper/battery_status_widget.dart';

// Main screen for Picture Taking functionalities
class PictureTakingScreen extends StatefulWidget {
  const PictureTakingScreen({Key? key}) : super(key: key);

  @override
  State<PictureTakingScreen> createState() => _PictureTakingScreenState();
}

class _PictureTakingScreenState extends State<PictureTakingScreen> {
  int _selectedIndex = 0;

  // Screens for BottomNavigationBar
  final List<Widget> _screens = [
    const PictureTakingContent(),
    const GalleryContent(),
    const CameraSettingsContent(),
  ];

  // Handles tab navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handles logout
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

  // Builds navigation menu from popup menu
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
            _navigateToMenuOption(context, value);
          }
        });
      },
    );
  }

  // Handle navigation menu options
  void _navigateToMenuOption(BuildContext context, String value) {
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Picture Taking',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              user?.email ?? 'Guest',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          const BatteryStatusWidget(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
        leading: _buildNavigationMenu(context),
      ),
      body: _screens[_selectedIndex], // Dynamic content based on navigation tab selection
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Take Picture',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Picture Taking Placeholder Widget
class PictureTakingContent extends StatelessWidget {
  const PictureTakingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Picture Taking Content Here',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

// Gallery Placeholder Widget
class GalleryContent extends StatelessWidget {
  const GalleryContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Gallery Content Here',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

// Camera Settings Placeholder Widget
class CameraSettingsContent extends StatelessWidget {
  const CameraSettingsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Camera Settings Content Here',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
