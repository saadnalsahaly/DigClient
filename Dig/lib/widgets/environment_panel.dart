import 'package:flutter/material.dart';

class EnvironmentPanel extends StatelessWidget {
  final Map<String, dynamic> environmentData;
  final bool isAutoControl;
  final VoidCallback onToggleControl;

  EnvironmentPanel({
    required this.environmentData,
    required this.isAutoControl,
    required this.onToggleControl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Environment Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReadingItem(
                  label: 'Temperature',
                  value: '${environmentData['temperature']}°C',
                  icon: Icons.thermostat,
                ),
                _buildReadingItem(
                  label: 'Humidity',
                  value: '${environmentData['humidity']}%',
                  icon: Icons.water_drop,
                ),
                _buildReadingItem(
                  label: 'Light',
                  value: '${environmentData['lightIntensity']} lux',
                  icon: Icons.wb_sunny,
                ),
              ],
            ),

            Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Auto Control', style: TextStyle(fontSize: 16)),
                Switch(
                  value: isAutoControl,
                  onChanged: (_) => onToggleControl(),
                  activeColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
