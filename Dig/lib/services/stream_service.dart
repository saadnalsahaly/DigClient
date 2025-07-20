import 'dart:convert';
import 'package:http/http.dart' as http;

int genId() {
  var now = DateTime.now().millisecondsSinceEpoch; // 13 digits
  var random = DateTime.now().microsecondsSinceEpoch % 100000; // 5 digits
  return int.parse('$now$random'); // 18 digits, still within safe range
}

class StreamService {
  Future<bool> openStream() async {
    print("Stream opened.");

    final notificationUrl = Uri.http("localhost:5284", "/api/Notification");

    try {
      final userCommandResponse = await http.post(
        notificationUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": genId(),
          "type": "stream",
          "content": "true",
          "dateTime": DateTime.now().toIso8601String()
        }),
      );

      return userCommandResponse.statusCode == 201;

    } catch (e) {
      print("Failed to open stream: $e");
      return false;
    }
  }

  Future<bool> closeStream() async {
    print("Stream closed.");
    final notificationUrl = Uri.http("localhost:5284", "/api/Notification");

    try {
      final userCommandResponse = await http.post(
        notificationUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id": genId(),
          "type": "stream",
          "content": "false",
          "dateTime": DateTime.now().toIso8601String()
        }),
      );

      return userCommandResponse.statusCode == 201;

    } catch (e) {
      print("Failed to open stream: $e");
      return false;
    }
  }
}