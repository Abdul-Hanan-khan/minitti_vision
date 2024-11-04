import 'dart:developer';

import 'package:get/get.dart';
import 'package:test_flutter/src/pages_data/health_data.dart';

class BloodOxygenController extends GetxController{
  // RxBool loadingBO = false.obs;

  late BleData bleData;

  @override
  void onInit() {
    bleData = BleData();
    super.onInit();
  }

  startBloodOxygen(){

    if(bleData.bloodOxygen.value>0){
      stopBloodOxygen();
    }
    bleData.measuringBloodOxygen.value = true;
    bleData.startBloodOxygen();
    // bleData.bloodOxygen.value;
    // bleData.streamSubscription!.onData((data){
    //   // print("list wow we are getting data ");
    //   // log(data.toString());
    // });

  }
  stopBloodOxygen(){

    if(bleData.measuringBloodOxygen.value){
      bleData.stopBloodOxygen();
      bleData.measuringBloodOxygen.value = false;
    }
    bleData.bloodOxygen.value =0;
    bleData.heartRate.value = 0;
    bleData.hrWaveList.clear();


  }



  @override
  void dispose() {
    bleData.dispose();
    super.dispose();
  }



}