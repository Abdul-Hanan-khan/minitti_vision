import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/controllers/ecg_controller.dart';
import 'package:test_flutter/src/controllers/home_controller.dart';
import 'package:test_flutter/src/widget/ecg_wave.dart';
import 'package:vibration/vibration.dart';

class EcgScreen extends StatelessWidget {
  HomeController homeController = Get.find();
  EcgController controller = Get.put(EcgController());

  EcgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          homeController.monitorBattery();
          controller.stopEcg();
          controller.bleData.clearEcgReadings();

          return true;
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                topSection(),
                testSection(context),
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
              controller.stopEcg();
              controller.bleData.clearEcgReadings();
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios)),
        Text("ECG"),
        Container()
      ],
    );
  }

  Widget testSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 200,
            // width: 10,
            child: EcgWave(homeController.bleData.waveData,
                homeController.bleData.ecgUpdate)),

        // Row(
        //   children: [
        //     Expanded(
        //       child: Container(
        //         margin: EdgeInsetsDirectional.only(top: 10),
        //         padding: EdgeInsetsDirectional.symmetric(vertical: 10),
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(7),
        //             color: Colors.white,
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.grey.withOpacity(0.2),
        //                 spreadRadius: 1,
        //                 blurRadius: 2,
        //                 offset: Offset(0, 3),
        //               )
        //             ]),
        //         child: SizedBox(
        //           height: 150,
        //             width: MediaQuery.of(context).size.width * 0.9,
        //             child: EcgWave(homeController.bleData.waveData,homeController.bleData.ecgUpdate)),
        //         // child: Obx(
        //         //   () => AnimatedContainer(
        //         //     height: 200,
        //         //     color: controller.measuringEcg.value
        //         //         ? Colors.orange.withOpacity(0.1)
        //         //         : Colors.blue.withOpacity(0.1),
        //         //     duration: Duration(milliseconds: 700),
        //         //     curve: Curves.easeInOut,
        //         //     child: Stack(
        //         //       alignment: Alignment.center,
        //         //       children: [
        //         //
        //         //         controller.measuringEcg.value == false && controller.bleData.heartRate.value == 0 && controller.bleData.hrWaveList.isEmpty
        //         //             ? Padding(
        //         //                 padding: const EdgeInsets.only(bottom: 20),
        //         //                 child: Text(
        //         //                   "Waiting for Test",
        //         //                   style: TextStyle(
        //         //                       fontSize: 10, color: Colors.blue),
        //         //                 ),
        //         //               )
        //         //             : Container()
        //         //       ],
        //         //     ),
        //         //   ),
        //         // ),
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.only(top: 10),
                padding: EdgeInsetsDirectional.all(10),
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
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ecgResultItem(
                            title: "RRI Maximum:",
                            value: controller.bleData.maxRR,
                            unit: "ms"),
                        ecgResultItem(
                            title: "RRI Minimum:",
                            value: controller.bleData.minRR,
                            unit: "ms")
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ecgResultItem(
                            title: "Heart Rate:",
                            value: controller.bleData.hr,
                            unit: "BPM"),
                        ecgResultItem(
                            title: "Hrv:",
                            value: controller.bleData.hrv,
                            unit: "ms")
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ecgResultItem(
                            title: "Respiratory Rate:",
                            value: controller.bleData.respiratoryRateV,
                            unit: "BPM"),
                        timerWidget()
                      ],
                    ),
                  ],
                ),
              ),
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
                if (!controller.bleData.measuringEcg.value) {
                  controller.startEcg();
                } else {
                  controller.stopEcg();
                }
              },
              child: Obx(
                () => AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.bleData.measuringEcg.value
                        ? Colors.red
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.bleData.measuringEcg.value
                        ? "Stop ECG"
                        : 'Start ECG',
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

  Widget ecgResultItem(
      {required String title,
      required RxInt value,
      required String unit,
      bool? isTimer}) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,style: TextStyle(fontSize: 12),),
            SizedBox(
              width: 2,
            ),
            Text(
              value.value.toString(),
              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              unit,
              style: TextStyle(fontSize: 10),
            ),
          ],
        ));
  }

  Widget timerWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Duration:"),
        SizedBox(
          width: 7,
        ),
        Obx(() => Text(
            "${controller.bleData.ecgMinutes.value.toString()}:${controller.bleData.ecgSeconds.value.toString()}")),
      ],
    );
  }
}
