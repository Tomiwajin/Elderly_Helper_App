import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elderly_helper/src/home_screen.dart'; // Import HomeScreen
import 'non_emergency_help_screen.dart'; // Import Non-Emergency Help screen
import 'request_meal_screen.dart';
import 'calendar_screen.dart';
import 'picture_taking_screen.dart';
import 'near_me_map_screen.dart';
import 'package:elderly_helper/battery_status_widget.dart'; // Battery status widget


class EmergencyHelpScreen extends StatefulWidget {
  const EmergencyHelpScreen({super.key});

  @override
  State<EmergencyHelpScreen> createState() => _EmergencyHelpScreenState();
}

class _EmergencyHelpScreenState extends State<EmergencyHelpScreen> {
  int _selectedIndex = 0; // Track the selected index of BottomNavigationBar

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
          const BatteryStatusWidget(),
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

class EmergencyHelpScreenContent extends StatefulWidget {
  const EmergencyHelpScreenContent({super.key});

  @override
  _EmergencyHelpScreenContentState createState() =>
      _EmergencyHelpScreenContentState();
}

class _EmergencyHelpScreenContentState extends State<EmergencyHelpScreenContent> {
  final _requesterController = TextEditingController();
  final _typeController = TextEditingController(text: 'Emergency Help'); // Automatically set to Emergency Help
  bool _isSubmitting = false;
  String _errorMessage = '';

  Future<void> _submitHelpRequest() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    // Prepare help request data
    final helpRequest = {
      'requester': _requesterController.text,
      'requestTime': DateTime.now().toIso8601String(), // Current time
      'type': _typeController.text, // Automatically set to 'Emergency Help'
    };

    try {
      // Send POST request to the backend
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/v1/help'), // Replace with your API URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode(helpRequest),
      );

      if (response.statusCode == 200) {
        // Successfully recorded the help request
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Help request received')),
        );
        _requesterController.clear();
      } else {
        setState(() {
          _errorMessage = 'Failed to submit request';
        });
        print('Failed to submit help request: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
      print('Error: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _requesterController,
            decoration: const InputDecoration(labelText: 'Requester Name'),
          ),
          // Make the Request Type field read-only and auto-set to 'Emergency Help'
          TextField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: 'Request Type'),
            readOnly: true, // Make this field non-editable
          ),
          const SizedBox(height: 20),
          _isSubmitting
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submitHelpRequest,
                  child: const Text('Submit Request'),
                ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
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
