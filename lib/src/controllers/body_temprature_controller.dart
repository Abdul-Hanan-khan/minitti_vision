import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/core/hc03_sdk.dart';
import 'package:test_flutter/src/core/protocol/Exception.dart';
import 'package:test_flutter/src/pages_data/health_data.dart';

class BodyTempController extends GetxController{
  RxBool loadingBodyTemp = false.obs;
  late BleData bleData;
  RxDouble bodyTemperature= 0.0.obs;
  @override
  void onInit() {
    bleData = BleData();
    // TODO: implement onInit
    super.onInit();
  }

  startBodyTemperature() async {
    loadingBodyTemp.value = true;
    bodyTemperature.value=0.0;
    bleData.startTemperature();
    bleData.temperatureData.listen((data){
      if(data is TemperatureData){
        bodyTemperature.value = data.temperature;
        loadingBodyTemp.value = false;
      }else if(data is AppException){
        bodyTemperature.value=0.0;
        loadingBodyTemp.value = false;
        Fluttertoast.showToast(
          msg: data.message.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
    // bleData.temperature.listen()
    // await Future.delayed(Duration(seconds: 5));
    // loadingBodyTemp.value = false;
  }

  stopBodyTemperature() async {
    // loadingBodyTemp.value = true;
    // await Future.delayed(Duration(seconds: 5));
    bodyTemperature.value = 0.0;
    loadingBodyTemp.value = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}