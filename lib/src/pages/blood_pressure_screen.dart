import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/controllers/blood_pressure_controller.dart';
import 'package:test_flutter/src/controllers/home_controller.dart';
import 'package:test_flutter/src/core/hc03_sdk.dart';
import 'package:test_flutter/src/core/protocol/Exception.dart';
import 'package:test_flutter/src/widget/dot_indicator.dart';
import 'package:test_flutter/src/widget/loader.dart';

class BloodPressureScreen extends StatelessWidget {
  BloodPressureController controller = Get.put(BloodPressureController());
  HomeController homeController = Get.find();
  BloodPressureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          homeController.monitorBattery();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [topSection(), testSection()],
              ),
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
              controller.bpResult = BloodPressureResult(0, 0, 0);
              controller.exception = AppException(message: "", type: ExceptionType.UNKNOWN);
              homeController.monitorBattery();
              Get.back();


            },
            child: Icon(Icons.arrow_back_ios)),
        Text("Blood Pressure",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
                          offset: Offset(0, 3))
                    ]),
                child: Obx(
                  () => RippleAnimation(
                    color: controller.loadingBloodPressure.value?Colors.red: Colors.blue,
                    size: 200.0,
                    lineWidth: 5.0,
                    loading: controller.loadingBloodPressure.value,
                    centerWidget: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                            )
                          ]),
                      child: Center(
                        child: controller.loadingBloodPressure.value
                            ? DotIndicators(
                                dotSize: 5,
                                dotSpacing: 3,
                              )
                            : controller.bpResult.ps != 0
                                ? Text(
                                    "${controller.bpResult.ps.toString()}/${controller.bpResult.pd.toString()}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      controller.startBloodPressure();
                                    },
                                    child: Text("Start")),
                      ),
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
                    ()=> Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Systolic\nPressure",
                            style: TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            controller.loadingBloodPressure.value || controller.bpResult.hr==0?  "0":controller.bpResult.ps.toString(),
                            style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "mmHa",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Diastolic\nPressure",
                            style: TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                          controller.loadingBloodPressure.value || controller.bpResult.hr==0?  "0":controller.bpResult.pd.toString(),
                            style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "mmHa",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Heart\nRate",
                            style: TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            controller.loadingBloodPressure.value || controller.bpResult.hr==0?  "0":controller.bpResult.hr.toString(),
                            style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "bom",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
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

                // controller.loadingBloodPressure.value = !controller.loadingBloodPressure.value;
                if(!controller.loadingBloodPressure.value){
                  controller.startBloodPressure();
                }else{
                  controller.stopBloodPressure();
                }
              },
              child: Obx(
                () => AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.loadingBloodPressure.value
                        ? Colors.red
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.loadingBloodPressure.value
                        ? "Stop Blood Pressure"
                        : 'Start Blood Pressure',
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
