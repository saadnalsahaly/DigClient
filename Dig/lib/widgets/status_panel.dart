import 'package:flutter/material.dart';

class StatusPanel extends StatelessWidget {
  final Map<String, dynamic> status;

  StatusPanel({required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: Colors.white
                ),
                SizedBox(width: 8),
                Text(
                  'Plant Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            _buildDiagnosisItem('Status:', status['disease']),
            _buildDiagnosisItem('Confidence:', '${status['confidence'] * 100}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}