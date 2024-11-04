import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/controllers/body_temprature_controller.dart';
import 'package:test_flutter/src/controllers/home_controller.dart';
import 'package:test_flutter/src/widget/dot_indicator.dart';
import 'package:test_flutter/src/widget/loader.dart';
class BodyTemperatureScreen extends StatelessWidget {
  HomeController homeController = Get.find();
   BodyTemperatureScreen({super.key});
   BodyTempController controller = Get.put(BodyTempController());

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
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Column(
              children: [
                topSection(),
                testSection()
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
            onTap: (){
              homeController.monitorBattery();
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios)),
        Text("Body Temperature"),
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
                    color: controller.loadingBodyTemp.value?Colors.red: Colors.blue,
                    size: 200.0,
                    lineWidth: 5.0,
                    loading: controller.loadingBodyTemp.value,
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
                        child: controller.loadingBodyTemp.value
                            ? DotIndicators(
                          dotSize: 5,
                          dotSpacing: 3,
                        )
                            : controller.bodyTemperature.value > 0
                            ? Text(
                          "${controller.bodyTemperature.value}",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        )
                            : GestureDetector(
                            onTap: () {
                              controller.startBodyTemperature();
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
                            "Body Temperature",
                            style: TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            controller.bodyTemperature.value.toString(),
                            style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "mmHa",
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
                if(!controller.loadingBodyTemp.value){
                  controller.startBodyTemperature();
                }else{
                  controller.stopBodyTemperature();
                }
              },
              child: Obx(
                    () => AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.loadingBodyTemp.value
                        ? Colors.red
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.loadingBodyTemp.value
                        ? "    Stop    "
                        : '    Start   ',
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
