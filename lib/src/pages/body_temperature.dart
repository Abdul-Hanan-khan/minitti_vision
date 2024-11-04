import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/controllers/home_controller.dart';
class BodyTemperatureScreen extends StatelessWidget {
  HomeController homeController = Get.find();
   BodyTemperatureScreen({super.key});

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
}
