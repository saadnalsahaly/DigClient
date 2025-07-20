import 'package:flutter/material.dart';
import '../services/plant_service.dart';
import '../services/environment_service.dart';
import '../widgets/environment_panel.dart';
import '../models/plant.dart';
import 'plant_detail_screen.dart';
import 'manual_control_screen.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> environmentData;

  HomeScreen({required this.environmentData});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlantService _plantService = PlantService();
  final EnvironmentService _environmentService = EnvironmentService();
  List<Plant> plants = [];
  bool isAutoControl = true;

  @override
  void initState() {
    super.initState();
    plants = _plantService.getAllPlants();
  }

  void toggleAutoControl() {
    setState(() {
      isAutoControl = !isAutoControl;
    });

    if (isAutoControl) {
      // Enable auto mode
      _environmentService.enableAutoControl();
    } else {
      // Navigate to manual control screen when switching to manual
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ManualControlScreen(
                environmentData: widget.environmentData,
                environmentService: _environmentService,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[900],
        title: Text(
          'My Garden',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        actions: [
          // Add a dedicated button for manual control
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                isAutoControl ? Icons.tune : Icons.auto_mode,
                color: isAutoControl ? Colors.white : Colors.amber[300],
                size: 26,
              ),
              tooltip:
                  isAutoControl
                      ? 'Switch to Manual Mode'
                      : 'Switch to Auto Mode',
              onPressed: () {
                if (isAutoControl) {
                  // Navigate to manual screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ManualControlScreen(
                            environmentData: widget.environmentData,
                            environmentService: _environmentService,
                          ),
                    ),
                  );
                } else {
                  // Switch back to auto mode
                  setState(() {
                    isAutoControl = true;
                    _environmentService.enableAutoControl();
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white10),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EnvironmentPanel(
                environmentData: widget.environmentData,
                isAutoControl: isAutoControl,
                onToggleControl: toggleAutoControl,
              ),

              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Plants',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 180, // Increased height for each item
                  ),
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    return _buildPlantCard(plants[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            // TODO: Add new plant functionality
          },
          child: Icon(Icons.add, size: 30),
          backgroundColor: Colors.green[900],
          elevation: 4,
          tooltip: 'Add New Plant',
        ),
      ),
    );
  }

  Widget _buildPlantCard(Plant plant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailScreen(plant: plant),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.black12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image takes most of the card height
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'plant-${plant.id}',
                        child: Container(
                          color: Colors.green.withOpacity(0.1),
                          child: Icon(
                            Icons.local_florist,
                            size: 40,
                            color: Colors.green[300],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Title area with minimal height
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 27, 32),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.eco, size: 16, color: Colors.green[600]),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          plant.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
