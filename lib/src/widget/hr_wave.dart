import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HrWave extends StatefulWidget {
  List<int> waveData;

  var update;
  var paintColor;

  HrWave({Key? key, required this.waveData, this.update, this.paintColor})
      : super(key: key);

  @override
  _HrWaveState createState() => _HrWaveState();
}

class _HrWaveState extends State<HrWave> {
  var offsetX = 0.0.obs;

  // Maximum number of data points to display
  final int maxDataPoints = 100; // You can adjust this value as needed

  @override
  void initState() {
    super.initState();
    // Ensure the waveData list is limited in size
    if (widget.waveData.length > maxDataPoints) {
      widget.waveData =
          widget.waveData.sublist(widget.waveData.length - maxDataPoints);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 100, // Set a fixed height for the wave
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              CustomPaint(
                painter: LinePainter(widget.waveData, widget.paintColor),
                size: Size(widget.waveData.length.toDouble(),
                    100), // Set width based on waveData length
              ),
              SizedBox(width: 5), // Space for the text
              Text(
                "${widget.update}",
                style: TextStyle(fontSize: 12, color: Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  List<int> waveData;
  var paintColor;

  LinePainter(this.waveData, this.paintColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (waveData.isEmpty) {
      return;
    }

    final paint = Paint()
      ..color = Color(paintColor)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final int minY = waveData.reduce(min);
    final int maxY = waveData.reduce(max);
    var dp = (maxY - minY).abs() / 75;
    if (dp == 0) {
      return;
    }

    for (var i = 1; i < waveData.length; i++) {
      int pointY1 = (waveData[i - 1] - minY) ~/ dp;
      int pointY2 = (waveData[i] - minY) ~/ dp;
      int pointX1 = i - 1;
      int pointX2 = i;
      canvas.drawLine(Offset(pointX1.toDouble(), pointY1.toDouble()),
          Offset(pointX2.toDouble(), pointY2.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      (oldDelegate as LinePainter).waveData != waveData;
}
