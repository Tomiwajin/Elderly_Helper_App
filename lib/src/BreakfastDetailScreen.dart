import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BreakfastDetailScreen extends StatefulWidget {
  final int comboId;

  const BreakfastDetailScreen({super.key, required this.comboId});

  @override
  _BreakfastDetailScreenState createState() => _BreakfastDetailScreenState();
}

class _BreakfastDetailScreenState extends State<BreakfastDetailScreen> {
  String breakfastDetail = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBreakfastDetail();
  }

  Future<void> _fetchBreakfastDetail() async {
    try {
      // Correct URL with slash between 'breakfast' and comboId
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/v1/meal/breakfast/${widget.comboId}'),
      );

      if (response.statusCode == 200) {
        // Directly assign response.body because it's plain text
        setState(() {
          breakfastDetail = response.body; // No need to decode
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load breakfast details';
        });
        print('Failed to load breakfast details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      print('Error occurred: $e');
    }
  }

  Future<void> _placeOrder() async {
    try {
      // POST request to place the order
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/v1/meal/breakfast/${widget.comboId}'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed: ${response.body}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order')),
        );
        print('Failed to place order. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breakfast Detail')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage')) // Show error message if any
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        breakfastDetail.isEmpty
                            ? 'No details available'
                            : breakfastDetail,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _placeOrder,
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
