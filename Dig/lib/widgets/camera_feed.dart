import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class CameraFeed extends StatelessWidget {
  final int plantId;

  CameraFeed({required this.plantId});

  @override
  Widget build(BuildContext context) {
    final streamUrl = 'http://localhost:5022/stream/';

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.black,
            insetPadding: EdgeInsets.all(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Mjpeg(
                stream: streamUrl,
                isLive: true,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Mjpeg(
            stream: streamUrl,
            isLive: true,
            fit: BoxFit.cover,
            error: (context, error, stack) => Center(
              child: Text(
                'Error loading stream',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
