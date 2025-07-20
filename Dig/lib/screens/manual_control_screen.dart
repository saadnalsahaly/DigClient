import 'package:flutter/material.dart';
import '../services/environment_service.dart';

class ManualControlScreen extends StatefulWidget {
  final Map<String, dynamic> environmentData;
  final EnvironmentService environmentService;

  ManualControlScreen({
    required this.environmentData,
    required this.environmentService,
  });

  @override
  _ManualControlScreenState createState() => _ManualControlScreenState();
}

class _ManualControlScreenState extends State<ManualControlScreen> {
  Map<String, double> manualSettings = {
    'temperature': 24.0,
    'humidity': 60.0,
    'lightIntensity': 70.0,
  };

  @override
  void initState() {
    super.initState();
    // Initialize with current settings and convert to double if they're strings
    manualSettings = {
      'temperature': _parseDouble(widget.environmentData['temperature'], 24.0),
      'humidity': _parseDouble(widget.environmentData['humidity'], 60.0),
      'lightIntensity': _parseDouble(widget.environmentData['lightIntensity'], 70.0),
    };

    // Set manual mode
    widget.environmentService.enableManualControl();
    widget.environmentService.setManualControls(manualSettings);
  }

  // Helper method to safely parse a value to double
  double _parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;

    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return defaultValue;
      }
    }
    return defaultValue;
  }

  void updateManualSetting(String setting, double value) {
    setState(() {
      manualSettings[setting] = value;
    });

    widget.environmentService.setManualControls(manualSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text(
          'Manual Control',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                Icons.auto_mode,
                color: Colors.white,
                size: 26,
              ),
              tooltip: 'Switch to Auto Mode',
              onPressed: () {
                widget.environmentService.enableAutoControl();
                Navigator.pop(context); // Return to home screen
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current environment status card
                Card(
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.only(bottom: 24, top: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Environment',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildEnvironmentInfo(),
                      ],
                    ),
                  ),
                ),

                // Manual control section
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
                  child: Text(
                    'Manual Environment Control',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Card(
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Temperature Control
                        _buildControlSection(
                          icon: Icons.thermostat,
                          title: 'Temperature',
                          value: '${manualSettings['temperature']!.toStringAsFixed(1)}°C',
                          sliderValue: manualSettings['temperature']!,
                          min: 15.0,
                          max: 35.0,
                          divisions: 40,
                          color: Colors.orange[600]!,
                          onChanged: (value) => updateManualSetting('temperature', value),
                        ),

                        Divider(height: 40, thickness: 1),

                        // Humidity Control
                        _buildControlSection(
                          icon: Icons.water_drop,
                          title: 'Humidity',
                          value: '${manualSettings['humidity']!.toStringAsFixed(1)}%',
                          sliderValue: manualSettings['humidity']!,
                          min: 30.0,
                          max: 90.0,
                          divisions: 60,
                          color: Colors.blue[600]!,
                          onChanged: (value) => updateManualSetting('humidity', value),
                        ),

                        Divider(height: 40, thickness: 1),

                        // Light Intensity Control
                        _buildControlSection(
                          icon: Icons.wb_sunny,
                          title: 'Light Intensity',
                          value: '${manualSettings['lightIntensity']!.toStringAsFixed(1)} lux',
                          sliderValue: manualSettings['lightIntensity']!,
                          min: 0.0,
                          max: 1000.0,
                          divisions: 40,
                          color: Colors.amber[600]!,
                          onChanged: (value) => updateManualSetting('lightIntensity', value),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Preset buttons
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
                  child: Text(
                    'Quick Presets',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPresetButton(
                      label: 'Tropical',
                      icon: Icons.forest,
                      color: Colors.green[600]!,
                      onPressed: () => _applyPreset({
                        'temperature': 28.0,
                        'humidity': 80.0,
                        'lightIntensity': 75.0,
                      }),
                    ),
                    _buildPresetButton(
                      label: 'Desert',
                      icon: Icons.wb_sunny,
                      color: Colors.amber[700]!,
                      onPressed: () => _applyPreset({
                        'temperature': 30.0,
                        'humidity': 40.0,
                        'lightIntensity': 90.0,
                      }),
                    ),
                    _buildPresetButton(
                      label: 'Temperate',
                      icon: Icons.terrain,
                      color: Colors.blue[600]!,
                      onPressed: () => _applyPreset({
                        'temperature': 22.0,
                        'humidity': 60.0,
                        'lightIntensity': 65.0,
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnvironmentInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoItem(
          icon: Icons.thermostat,
          value: '${_parseDouble(widget.environmentData['temperature'], 24.0).toStringAsFixed(1)}°C',
          label: 'Temperature',
          color: Colors.orange[600]!,
        ),
        _buildInfoItem(
          icon: Icons.water_drop,
          value: '${_parseDouble(widget.environmentData['humidity'], 60.0).toStringAsFixed(1)}%',
          label: 'Humidity',
          color: Colors.blue[600]!,
        ),
        _buildInfoItem(
          icon: Icons.wb_sunny,
          value: '${_parseDouble(widget.environmentData['lightIntensity'], 70.0).toStringAsFixed(1)}%',
          label: 'Light',
          color: Colors.amber[600]!,
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlSection({
    required IconData icon,
    required String title,
    required String value,
    required double sliderValue,
    required double min,
    required double max,
    required int divisions,
    required Color color,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withOpacity(0.2),
            thumbColor: Colors.white,
            overlayColor: color.withOpacity(0.2),
            valueIndicatorColor: color,
            trackHeight: 6.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
          ),
          child: Slider(
            value: sliderValue,
            min: min,
            max: max,
            divisions: divisions,
            label: value,
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              min.round().toString() + (title == 'Temperature' ? '°C' : '%'),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              max.round().toString() + (title == 'Temperature' ? '°C' : '%'),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _applyPreset(Map<String, double> presetValues) {
    setState(() {
      manualSettings = presetValues;
    });
    widget.environmentService.setManualControls(manualSettings);
  }
}