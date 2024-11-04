import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/core/hc03_sdk.dart';
import 'package:test_flutter/src/core/protocol/Exception.dart';
import 'package:test_flutter/src/pages_data/health_data.dart';

class BloodPressureController  extends GetxController{
  RxBool loadingBloodPressure = false.obs;
  BloodPressureResult bpResult = BloodPressureResult(0, 0, 0);
  AppException exception = AppException(message: "", type: ExceptionType.UNKNOWN);
    late BleData bleData;
  StreamSubscription? _bpSubscription;




  @override
  void onInit() {
    bleData = BleData();
    super.onInit();
  }



  startBloodPressure() {
    loadingBloodPressure.value = true;
    bleData.startBloodPressure();
    _bpSubscription = bleData.myBpResponse.listen((bpData) {
      if (bpData is BloodPressureResult) {
        bpResult = bpData;
        _bpSubscription?.cancel();
        exception = AppException(message: "", type: ExceptionType.UNKNOWN);
        loadingBloodPressure.value = false;
      }
      if (bpData is AppException) {
        exception = bpData;
        _bpSubscription?.cancel();
        bpResult = BloodPressureResult(0, 0, 0);
        if(bpData.type == ExceptionType.BP_ERR_CODE_LEAK_RETRY){
          showErrorMessage("You need to stay calm during test. Try Again");
        }else{
          showErrorMessage("Please make sure there is device is proper connect to cuff and there is no air leak");
        }
        loadingBloodPressure.value = false;
      }
    });
  }

  stopBloodPressure() {
    bleData.stopBloodPressure();
    loadingBloodPressure.value = false;
    exception = AppException(message: "", type: ExceptionType.UNKNOWN);
    bpResult = BloodPressureResult(0, 0, 0);
  }

  @override
  void dispose() {
    bleData.dispose();
    super.dispose();
  }

  void showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

}