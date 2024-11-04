import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/controllers/blood_oxygen_controller.dart';
import 'package:test_flutter/src/controllers/connectivity_controller.dart';
import 'package:test_flutter/src/controllers/home_controller.dart';
import 'package:test_flutter/src/widget/dot_indicator.dart';
import 'package:test_flutter/src/widget/hr_wave.dart';
import 'package:test_flutter/src/widget/loader.dart';

class BloodOxygenScreen extends StatelessWidget {
  BloodOxygenScreen({super.key});

  BloodOxygenController controller = Get.put(BloodOxygenController());
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          homeController.monitorBattery();
          controller.stopBloodOxygen();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [topSection(), testSection()],
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
              Get.back();
              homeController.monitorBattery();
              controller.stopBloodOxygen();
            },
            child: Icon(Icons.arrow_back_ios)),
        Text("Blood Oxygen"),
        Container()
      ],
    );
  }

  Widget testSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.only(top: 10),
                padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3),
                      )
                    ]),
                child: Obx(
                  () => AnimatedContainer(
                    height: 200,
                    color: controller.bleData.measuringBloodOxygen.value
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        HrWave(
                            waveData: controller.bleData.hrWaveList,
                            update: controller.bleData.hrWaveUpdate,
                            paintColor: 0xFFFF9000),
                        controller.bleData.measuringBloodOxygen.value == false && controller.bleData.heartRate.value == 0 && controller.bleData.hrWaveList.isEmpty
                            ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text("Waiting for Test",style: TextStyle(fontSize: 10,color: Colors.blue),),
                            )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                  margin: EdgeInsetsDirectional.only(top: 10),
                  padding: EdgeInsetsDirectional.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3))
                      ]),
                  child: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Blood\nOxygen",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "${controller.bleData.bloodOxygen.value}",
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Heart\nRate",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "${controller.bleData.heartRate.value}",
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              "bpm",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // controller.loadingBO.value = !controller.loadingBO.value;
                if (!controller.bleData.measuringBloodOxygen.value) {
                  controller.startBloodOxygen();
                } else {
                  controller.stopBloodOxygen();
                }
              },
              child: Obx(
                () => AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.bleData.measuringBloodOxygen.value
                        ? Colors.red
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.bleData.measuringBloodOxygen.value
                        ? "Stop Blood Oxygen"
                        : 'Start Blood Oxygen',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
