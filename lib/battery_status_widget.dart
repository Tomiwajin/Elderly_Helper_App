import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryStatusWidget extends StatefulWidget {
  const BatteryStatusWidget({Key? key}) : super(key: key);

  @override
  _BatteryStatusWidgetState createState() => _BatteryStatusWidgetState();
}

class _BatteryStatusWidgetState extends State<BatteryStatusWidget> {
  final Battery _battery = Battery();
  int _batteryLevel = 100; // Default starting battery value

  @override
  void initState() {
    super.initState();
    _initializeBattery();
  }

  /// Fetch battery status on startup and listen for battery state changes
  Future<void> _initializeBattery() async {
    try {
      // Get initial battery percentage
      final level = await _battery.batteryLevel;
      setState(() {
        _batteryLevel = level;
      });

      // Listen for changes in battery state
      _battery.onBatteryStateChanged.listen((_) async {
        final newLevel = await _battery.batteryLevel;
        if (newLevel != _batteryLevel) {
          setState(() {
            _batteryLevel = newLevel;
          });
        }
      });
    } catch (e) {
      debugPrint("Error accessing battery status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensures it takes only necessary space
      children: [
        const Icon(Icons.battery_full, size: 20),
        const SizedBox(width: 4),
        Text(
          "$_batteryLevel%",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _battery.onBatteryStateChanged.drain();
  }
}
