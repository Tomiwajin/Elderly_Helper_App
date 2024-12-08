import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'BreakfastDetailScreen.dart';

class BreakfastListScreen extends StatefulWidget {
  const BreakfastListScreen({super.key});

  @override
  _BreakfastListScreenState createState() => _BreakfastListScreenState();
}

class _BreakfastListScreenState extends State<BreakfastListScreen> {
  List<String> breakfastCombos = [];
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // Store error message if fetching fails

  @override
  void initState() {
    super.initState();
    _fetchBreakfastCombos();
  }

  Future<void> _fetchBreakfastCombos() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/v1/meal/breakfast')); 

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          breakfastCombos = List<String>.from(data);  // Directly cast the response to List<String>
          isLoading = false;
        });
      } else {
        print('Failed to load breakfast combos. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load breakfast combos';
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breakfast Options')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage')) // Show error message if any
              : ListView.builder(
                  itemCount: breakfastCombos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(breakfastCombos[index]),
                      onTap: () {
                        // Navigate to the Breakfast Detail Screen with the selected combo ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BreakfastDetailScreen(comboId: index + 1), // Passing the combo ID
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
