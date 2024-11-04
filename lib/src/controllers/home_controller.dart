import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/controllers/connectivity_controller.dart';
import 'package:test_flutter/src/core/hc03_sdk.dart';
import 'package:test_flutter/src/core/protocol/Exception.dart';
import 'package:test_flutter/src/pages_data/health_data.dart';

class HomeController extends GetxController {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  RxBool loadingBatterData = false.obs;
  late BleData bleData;
  Timer? batteryTimer;

  // StreamSubscription? _batterSubscription;
  RxBool isBatteryCharging = false.obs;
  RxInt batteryLevel = 0.obs;

  @override
  void onInit() {
    bleData = BleData();
    super.onInit();
  }

  monitorBattery() {
    batteryTimer = Timer.periodic(Duration(milliseconds:2500), (timer) async {
      bleData.startBattery();
      loadingBatterData.value = true;

      bleData.myBatteryResponse.listen((batteryData) {
        print("batter level is ${batteryData.batteryLevel}");
        if (batteryData is BatteryLevelData) {
          batteryLevel.value = batteryData.batteryLevel;
          isBatteryCharging.value = false;
          loadingBatterData.value = false;
          //not charging
        }
        if (batteryData is BatteryChargingStatus) {
          batteryLevel.value = int.parse(batteryData.batteryLevel.toString());
          isBatteryCharging.value = true;
          loadingBatterData.value = false;
          // charging with
        }
      });
    });
  }

  void checkAndMonitorBattery() async {
    monitorBattery(); // this line of code will be executed only once in app life cycle
    connectivityController.scanDes.listen((connection) {
      if (connection == "Disconnect") {
        monitorBattery();
      } else if (connection == "Connect") {
        if (batteryTimer != null) {
          batteryTimer!.cancel();
        }
      }
    });
  }

  void stopBatteryMonitor(){
    if (batteryTimer != null) {
      batteryTimer!.cancel();
    }
  }


  @override
  void dispose() {
    bleData.dispose();
    batteryTimer?.cancel();
    super.dispose();
  }
}
