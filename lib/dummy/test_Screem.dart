import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_flutter/dummy/dummy_ecg_widget.dart';
// Import your ECG widget



class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Real-time ECG Widget')),
      body: Center(child: RealisticECGWidget(isRunning: RxBool(true))),
    );
  }
}
