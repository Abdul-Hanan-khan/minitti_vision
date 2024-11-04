import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/controllers/home_controller.dart';
import 'package:vibration/vibration.dart';

class EcgScreen extends StatelessWidget {
  HomeController homeController = Get.find();

  EcgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          homeController.monitorBattery();
          return true;
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                topSection(),
                testSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topSection() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
            onTap: () {
              homeController.monitorBattery();
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios)),
        Text("ECG"),
        Container()
      ],
    );
  }

  Widget testSection() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate(
                  duration: 500); // Vibrate for 0.5s on button press
            }
          },
          child: Text("Vibrate Phone"),
        ),
        // CustomLoader()
      ],
    );
  }
}
