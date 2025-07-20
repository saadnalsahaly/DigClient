import 'dart:convert';
import 'package:http/http.dart' as http;

int genId() {
  var now = DateTime.now().millisecondsSinceEpoch; // 13 digits
  var random = DateTime.now().microsecondsSinceEpoch % 100000; // 5 digits
  return int.parse('$now$random'); // 18 digits, still within safe range
}

class EnvironmentService {
  Future<Map<String, dynamic>> getCurrentEnvironment() async {
    final environmentUrl = Uri.http("localhost:5284", "/api/Environment", {"latest": "1"});
    final environmentData = await http.read(environmentUrl);
    final object = json.decode(environmentData)[0];
    return {
      'temperature': object["temperature"],
      'humidity': object["humidity"],
      'lightIntensity': object["lightIntensity"],
    };
  }

  Future<bool> enableAutoControl() async {
    print('Auto control enabled');
    final opModUrl = Uri.http("localhost:5284", "/api/OperationMode");

    try {
      final response = await http.post(
        opModUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": genId(),
          "mode": "Automatic",
          "dateTime": DateTime.now().toIso8601String()
        }),
      );

      return response.statusCode == 201;

    } catch (e) {
      print("Failed to enable auto control: $e");
      return false;
    }
  }

  Future<bool> enableManualControl() async {
    print('Manual control enabled');
    final opModUrl = Uri.http("localhost:5284", "/api/OperationMode");

    try {
      final response = await http.post(
        opModUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": genId(),
          "mode": "Manual",
          "dateTime": DateTime.now().toIso8601String()
        }),
      );

      return response.statusCode == 201;

    } catch (e) {
      print("Failed to enable auto control: $e");
      return false;
    }
  }


  Future<bool> setManualControls(Map<String, double> settings) async {
    print('Manual controls set: $settings');

    final userCommandUrl = Uri.http("localhost:5284", "/api/UserCommand");

    try {
      final userCommandResponse = await http.post(
        userCommandUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": genId(),
          "temperature": settings["temperature"],
          "humidity": settings["humidity"],
          "lightIntensity": settings["lightIntensity"],
          "dateTime": DateTime.now().toIso8601String()
        }),
      );

      return userCommandResponse.statusCode == 201;

    } catch (e) {
      print("Failed to enable auto control: $e");
      return false;
    }
  }
}