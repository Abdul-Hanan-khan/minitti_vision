import 'package:get/get.dart';
import 'package:test_flutter/src/pages_data/health_data.dart';

class EcgController extends GetxController {
  // RxBool measuringEcg = false.obs;
  late BleData bleData;

  @override
  void onInit() {
    bleData = BleData();
    // TODO: implement onInit
    super.onInit();
  }

  startEcg() {
    bleData.measuringEcg.value = true;
    bleData.startEcg();
  }

  stopEcg() {
    bleData.measuringEcg.value = false;
    bleData.stopEcg();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
