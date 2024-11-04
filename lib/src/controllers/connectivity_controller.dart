


import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/bluetooth/bluetooth_manager.dart';
import 'package:test_flutter/src/controllers/home_controller.dart';
import 'package:test_flutter/src/pages_data/health_data.dart';
import 'package:test_flutter/src/permission/permission_manager.dart';

class ConnectivityController extends GetxController{
  late BlueToothManager blueToothManager;
  late RxList deviceList;
  RxBool isScan = false.obs;
  late Function scanCallBack;
  late Function connectCallBack;
  BluetoothDevice? connectDevice;
  RxString scanDes = "Connect".obs;
  RxBool isShowBtn = false.obs;
  RxBool isBleConnect = false.obs;



  @override
  void onInit() {
    // TODO: implement onInit
    requestBlePermissions();
    initBle();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    blueToothManager.removeScanListener(scanCallBack);

    super.dispose();
  }

  void initBle() {
    blueToothManager = BlueToothManager();
    scanCallBack = (isScanning) {
      scanDes.value = isScanning ? "Scanning" : "Connect";
      isScan.value = true;
    };
    blueToothManager.addScanListener(scanCallBack);
    connectCallBack = (device, isConnect) async {
      connectDevice = device;
      isBleConnect.value = isConnect;
      isShowBtn.value = isConnect;
      if (isConnect) {
        BleData bleData = BleData();
        bleData.init();
        isScan.value = false;
        Future.delayed(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
          // widget.tabIndex.value = 1;
        });
      } else {
        isScan.value = false;
        print("Auto start scanning from init");
        // blueToothManager.startScan();
        // widget.tabIndex. value = 0;
        debugPrint(
            "=================================================isConnect=$isConnect");
      }
    };
    blueToothManager.addConnectListener(connectCallBack);
  }
}