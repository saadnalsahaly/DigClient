import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/plant_service.dart';
import '../services/stream_service.dart';
import '../widgets/camera_feed.dart';
import '../widgets/status_panel.dart';
import 'dart:async';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;

  PlantDetailScreen({required this.plant});

  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  final PlantService _plantService = PlantService();
  final StreamService _streamService = StreamService();
  Map<String, dynamic>? diagnosisData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateData();
    _streamService.openStream();
    // Simulate live updates
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      _updateData();
    });
  }

  Future<void> _updateData() async {

    // 2) only fetch diagnosis if there is an issue
    Map<String, dynamic>? newDiagnosis;
    if (true) {
      // await the Future here!
      newDiagnosis = await _plantService
          .getStatus(widget.plant.id.toString());
    }

    // 3) now update state once, with both values ready
    setState(() {
      diagnosisData = newDiagnosis;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamService.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (diagnosisData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.plant.name),
          elevation: 0,
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.green.shade600,
              ),
              SizedBox(height: 16),
              Text('Loading plant data...')
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.plant.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Plant settings action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(color: Colors.white10),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Camera feed with overlay info
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: CameraFeed(plantId: widget.plant.id),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Live View',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content area
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plant status card
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 16),
                        child: StatusPanel(status: diagnosisData!)
                      ),

                      // Care tips
                      SizedBox(height: 24),
                      _buildCareTips(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTips() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber.shade600,
                ),
                SizedBox(width: 8),
                Text(
                  'Care Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildTipItem('Water every 3-4 days or when soil feels dry'),
            _buildTipItem('Place in bright, indirect sunlight'),
            _buildTipItem('Fertilize once a month during growing season'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: Colors.green.shade600,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}