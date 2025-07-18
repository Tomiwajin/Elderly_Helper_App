import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Required for JSON encoding and decoding
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elderly_helper/src/home_screen.dart'; // Import HomeScreen
import 'request_meal_screen.dart';
import 'calendar_screen.dart';
import 'picture_taking_screen.dart';
import 'near_me_map_screen.dart';
import 'package:elderly_helper/battery_status_widget.dart'; // Import the Battery Status Widget

class NonEmergencyHelpScreen extends StatefulWidget {
  const NonEmergencyHelpScreen({super.key});

  @override
  State<NonEmergencyHelpScreen> createState() => _NonEmergencyHelpScreenState();
}

class _NonEmergencyHelpScreenState extends State<NonEmergencyHelpScreen> {
  int _selectedIndex = 0; // Track the selected index of BottomNavigationBar

  final List<Widget> _screens = [
    const NonEmergencyHelpScreenContent(), // Non-Emergency Help screen content
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
              'Non-Emergency Help',
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
            icon: Icon(Icons.healing),
            label: 'Non-Emergency',
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

class NonEmergencyHelpScreenContent extends StatefulWidget {
  const NonEmergencyHelpScreenContent({super.key});

  @override
  _NonEmergencyHelpScreenContentState createState() =>
      _NonEmergencyHelpScreenContentState();
}

class _NonEmergencyHelpScreenContentState
    extends State<NonEmergencyHelpScreenContent> {
  final _requesterController = TextEditingController();
  final _typeController = TextEditingController(text: 'Non-Emergency Help'); // Pre-set to Non-Emergency Help
  bool _isSubmitting = false;
  String _errorMessage = '';

  // Function to submit the help request
  Future<void> _submitHelpRequest() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    // Prepare help request data
    final helpRequest = {
      'requester': _requesterController.text,
      'requestTime': DateTime.now().toIso8601String(), // Automatically set to current time
      'type': _typeController.text, // Pre-set to 'Non-Emergency Help'
    };

    try {
      // Send POST request to the backend
      final response = await http.post(
        Uri.parse('http://yoursite/api/v1/help'), // Replace with your API URL
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
          // Requester Name Input
          TextField(
            controller: _requesterController,
            decoration: const InputDecoration(labelText: 'Requester Name'),
          ),
          // Request Type (Non-Emergency Help) pre-filled and read-only
          TextField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: 'Request Type'),
            readOnly: true, // Make this field non-editable
          ),
          const SizedBox(height: 20),
          // Submit Button or Loading Indicator
          _isSubmitting
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submitHelpRequest,
                  child: const Text('Submit Request'),
                ),
          // Error Message Display
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
