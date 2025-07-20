import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant.dart';

class PlantService {
  List<Plant> getAllPlants() {
    // Due to Raspberry pi supporting only two cameras we hard coded these ids.
    return [
      Plant(
        id: 1,
        name: 'Plant 1',
      ),
      Plant(
        id: 2,
        name: 'Plant 2',
      ),
    ];
  }

  Future<Map<String, dynamic>>? getStatus(String plantId) async {
    final uri = Uri.parse('http://localhost:5284/api/PlantStatus/Plant/$plantId');
    final resp = await http.get(uri);

    if (resp.statusCode != 200)
      print("Not successful: ${resp.body}");

    final List<dynamic> list = jsonDecode(resp.body);
    if (list.isEmpty)
      print("Invalid response");

    // pick the most recent
    final latest = list.last as Map<String, dynamic>;
    return latest;
  }
}