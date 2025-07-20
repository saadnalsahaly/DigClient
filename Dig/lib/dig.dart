import 'package:flutter/material.dart';
import 'dart:async';
import 'screens/home_screen.dart';
import 'services/environment_service.dart';

void main() {
  runApp(GardeningApp());
}

class GardeningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Monitor',
      theme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final EnvironmentService _environmentService = EnvironmentService();
  late Map<String, dynamic> environmentData = Map();
  Timer? _timer;

  @override
  void initState()  {
    super.initState();
    _loadEnvironmentData();

    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      setState(() {
        _loadEnvironmentData();
      });
    });
  }

  Future<void> _loadEnvironmentData() async {
    try {
      var data = await _environmentService.getCurrentEnvironment();
      setState(() {
        environmentData = data;
      });
    } catch (e) {
      print('Error fetching environment data: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(environmentData: environmentData);
  }
}