import 'package:flutter/material.dart';

class ExternalDeviceBatteryWidget extends StatefulWidget {
   int batteryLevel;
   bool isCharging;


   ExternalDeviceBatteryWidget({required this.batteryLevel,this.isCharging = false});

  @override
  _ExternalDeviceBatteryWidgetState createState() =>
      _ExternalDeviceBatteryWidgetState();
}

class _ExternalDeviceBatteryWidgetState
    extends State<ExternalDeviceBatteryWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 25,
                  height: 12,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Stack(
                     alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: widget.batteryLevel / 100,
                          // Adjust fill level dynamically
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.batteryLevel > 20
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(2.0),
                            ),

                          ),
                        ),
                      ),
                   if(widget.isCharging) Center(child: Icon(Icons.electric_bolt_sharp,color: Colors.black,size: 7,))
                    ],
                  ),
                ),
                Container(
                  width: 2,
                  height: 6,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                )
              ],
            ),
            Positioned(
              right: -8,
              child: Container(
                width: 4,
                height: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(width: 3),
        Text(
          '${widget.batteryLevel}%', // Display battery percentage
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
