import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RealisticECGWidget extends StatelessWidget {
  final RxBool isRunning;
  final RxList<Offset> ecgPoints = <Offset>[].obs;
  final double xIncrement = 2.0;
  Timer? _timer;

  RealisticECGWidget({required this.isRunning});

  // Predefined ECG pattern (P wave, QRS complex, T wave)
  final List<double> ecgPattern = [
    0, 1, 0, -1, 0,  // P wave
    -3, 5, -8, 10, -8, 3, 0, // QRS complex
    1, 2, 1, 0, // T wave
    0, 0, 0 // Return to baseline
  ];

  int patternIndex = 0; // Track position in the ECG pattern

  void _startOrStopWave() {
    if (isRunning.value) {
      _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
        final xOffset = (ecgPoints.isEmpty ? 0 : ecgPoints.last.dx) + xIncrement;
        ecgPoints.add(Offset(
          xOffset,
          ecgPattern[patternIndex] * 5 + 50, // Scale and shift the pattern
        ));

        // Loop through pattern
        patternIndex = (patternIndex + 1) % ecgPattern.length;
      });
    } else {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reactively listen to isRunning changes
    ever(isRunning, (_) => _startOrStopWave());

    return Obx(() {
      // Calculate total width based on points
      double totalWidth = ecgPoints.isNotEmpty ? ecgPoints.last.dx : 0;

      return SizedBox(
        width: Get.width * 0.8, // Occupy 80% of the screen width
        height: 100,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: CustomPaint(
            size: Size(totalWidth, 100),
            painter: ECGWavePainter(ecgPoints.toList()),
          ),
        ),
      );
    });
  }
}

class ECGWavePainter extends CustomPainter {
  final List<Offset> ecgPoints;

  ECGWavePainter(this.ecgPoints);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (ecgPoints.isNotEmpty) {
      path.moveTo(ecgPoints.first.dx, ecgPoints.first.dy);
      for (var point in ecgPoints) {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ECGWavePainter oldDelegate) => true;
}
