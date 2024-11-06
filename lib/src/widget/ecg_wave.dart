
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EcgWave extends StatefulWidget {
  List wave;

  RxBool update;

  EcgWave(List this.wave, RxBool this.update, {Key? key}) : super(key: key);

  @override
  _EcgWaveState createState() => _EcgWaveState();
}

class _EcgWaveState extends State<EcgWave> {
  // var offsetX = 0.0.obs;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int height = 101;
    int width = 451;
   return Obx(
          () => Container(
        height: 100, // Set a fixed height for the wave
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: Row(
            children: [


              CustomPaint(
                foregroundPainter:  LinePainter(widget.wave),
                painter:GridPainter(1.24, height, width),
                size: Size(500, 100), // Set width based on waveData length
              ),
              SizedBox(width: 5), // Space for the text
              Text(
                "${widget.update}",
                style: TextStyle(fontSize: 2, color: Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  var px;
  var height;
  var width;
  GridPainter(this.px, this.height, this.width);
  @override
  void paint(Canvas canvas, Size size) {
    final smallPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path smallPath = Path();
    drawSmallGrid(smallPath, width, height);
    canvas.drawPath(smallPath, smallPaint);
    Path bigPath = Path();
    final bigPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    drawBigGrid(bigPath, width, height);
    canvas.drawPath(bigPath, bigPaint);
  }

  //画小的表格背景
  void drawSmallGrid(path, int width, int height) {
    for (int x = 0; x < width; x += 5) {
      path.moveTo(x * px, 0.0);
      path.lineTo(x * px, height * px);
    }

    for (int y = 0; y < height; y += 5) {
      path.moveTo(0.0, y * px);
      path.lineTo(width * px, y * px);
    }
    // path.close();
  }

  void drawBigGrid(path, width, height) {
    for (int x = 0; x < width; x += 25) {
      path.moveTo(x * px, 0.0);
      path.lineTo(x * px, height * px);
    }

    for (int y = 0; y < height; y += 25) {
      path.moveTo(0.0, y * px);
      path.lineTo(width * px, y * px);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class LinePainter extends CustomPainter {
  List waveData;

  int xs = 0;
  double speedX = 0.0;
  double yScale = 0.0;

  LinePainter(this.waveData);

  @override
  void paint(Canvas canvas, Size size) {
    if (waveData.isEmpty) {
      return;
    }
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    Path path = Path();
    speedX = getSpeed();
    for (int index = 0; index < waveData.length; index++) {
      path.lineTo((speedX * index).toDouble(), getY(waveData[index]));
    }
    canvas.drawPath(path, paint);
  }

  double getY(data) {
    if(data >7000){
      data = 7000;
    }
    if(data<-7000){
      data = -7000;
    }
    int height = 127;
    if (xs == 0) {
      xs = getxS();
    }
    if (yScale == 0) {
      yScale = getYScale(2);
    }
    return (height / 2 + ((((data * 18.3) / 128) * xs) / 100) * yScale)
        .toDouble();
  }

  getSpeed() {
    const DATA_PER_SEC = 512;
    const mode = 1;

    int scale = getXScale(1);
    var dataPerLattice = DATA_PER_SEC / (25 * scale);
    return getxS() / dataPerLattice;
  }

  double getYScale(type) {
    double scale = 0.0;
    switch (type) {
      case 1:
        scale = 0.5; //5mm/mV
        break;
      case 2:
        scale = 1.0; //10mm/mV
        break;
      case 3:
        scale = 2.0; //20mm/mV
        break;
    }
    return scale;
  }

  int getxS() {
    const spac1 = 5;
    return spac1;
  }

  int getXScale(type) {
    int scale = 0;
    switch (type) {
      case 1:
        scale = 1; //25mm/s
        break;
      case 2:
        scale = 2; //50mm/s
        break;
    }
    return scale;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      (oldDelegate as LinePainter).waveData != waveData;
}








//
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class EcgWave extends StatefulWidget {
//   List wave;
//
//   RxBool update;
//
//   EcgWave(List this.wave, RxBool this.update, {Key? key}) : super(key: key);
//
//   @override
//   _EcgWaveState createState() => _EcgWaveState();
// }
//
// class _EcgWaveState extends State<EcgWave> {
//   // var offsetX = 0.0.obs;
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int height = 101;
//     int width = 451;
//    return Obx(
//           () => Container(
//         height: 100, // Set a fixed height for the wave
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: NeverScrollableScrollPhysics(),
//           child: Row(
//             children: [
//
//
//               CustomPaint(
//                 foregroundPainter:  LinePainter(widget.wave),
//                 painter:GridPainter(1.24, height, width),
//                 size: Size(500, 100), // Set width based on waveData length
//               ),
//               SizedBox(width: 5), // Space for the text
//               Text(
//                 "${widget.update}",
//                 style: TextStyle(fontSize: 2, color: Colors.transparent),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class GridPainter extends CustomPainter {
//   var px;
//   var height;
//   var width;
//   GridPainter(this.px, this.height, this.width);
//   @override
//   void paint(Canvas canvas, Size size) {
//     final smallPaint = Paint()
//       ..color = Colors.yellow
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//
//     Path smallPath = Path();
//     drawSmallGrid(smallPath, width, height);
//     canvas.drawPath(smallPath, smallPaint);
//     Path bigPath = Path();
//     final bigPaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 1
//       ..style = PaintingStyle.stroke;
//     drawBigGrid(bigPath, width, height);
//     canvas.drawPath(bigPath, bigPaint);
//   }
//
//   //画小的表格背景
//   void drawSmallGrid(path, int width, int height) {
//     for (int x = 0; x < width; x += 5) {
//       path.moveTo(x * px, 0.0);
//       path.lineTo(x * px, height * px);
//     }
//
//     for (int y = 0; y < height; y += 5) {
//       path.moveTo(0.0, y * px);
//       path.lineTo(width * px, y * px);
//     }
//     // path.close();
//   }
//
//   void drawBigGrid(path, width, height) {
//     for (int x = 0; x < width; x += 25) {
//       path.moveTo(x * px, 0.0);
//       path.lineTo(x * px, height * px);
//     }
//
//     for (int y = 0; y < height; y += 25) {
//       path.moveTo(0.0, y * px);
//       path.lineTo(width * px, y * px);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
// class LinePainter extends CustomPainter {
//   List waveData;
//
//   int xs = 0;
//   double speedX = 0.0;
//   double yScale = 0.0;
//
//   LinePainter(this.waveData);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (waveData.isEmpty) {
//       return;
//     }
//     final paint = Paint()
//       ..color = Colors.red
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;
//     Path path = Path();
//     speedX = getSpeed();
//     for (int index = 0; index < waveData.length; index++) {
//       path.lineTo((speedX * index).toDouble(), getY(waveData[index]));
//     }
//     canvas.drawPath(path, paint);
//   }
//
//   double getY(data) {
//     if(data >7000){
//       data = 7000;
//     }
//     if(data<-7000){
//       data = -7000;
//     }
//     int height = 127;
//     if (xs == 0) {
//       xs = getxS();
//     }
//     if (yScale == 0) {
//       yScale = getYScale(2);
//     }
//     return (height / 2 + ((((data * 18.3) / 128) * xs) / 100) * yScale)
//         .toDouble();
//   }
//
//   getSpeed() {
//     const DATA_PER_SEC = 512;
//     const mode = 1;
//
//     int scale = getXScale(1);
//     var dataPerLattice = DATA_PER_SEC / (25 * scale);
//     return getxS() / dataPerLattice;
//   }
//
//   double getYScale(type) {
//     double scale = 0.0;
//     switch (type) {
//       case 1:
//         scale = 0.5; //5mm/mV
//         break;
//       case 2:
//         scale = 1.0; //10mm/mV
//         break;
//       case 3:
//         scale = 2.0; //20mm/mV
//         break;
//     }
//     return scale;
//   }
//
//   int getxS() {
//     const spac1 = 5;
//     return spac1;
//   }
//
//   int getXScale(type) {
//     int scale = 0;
//     switch (type) {
//       case 1:
//         scale = 1; //25mm/s
//         break;
//       case 2:
//         scale = 2; //50mm/s
//         break;
//     }
//     return scale;
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) =>
//       (oldDelegate as LinePainter).waveData != waveData;
// }
