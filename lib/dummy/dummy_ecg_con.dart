import 'package:get/get.dart';
import 'dart:async';
import 'dart:math'; // For generating the simulated ECG values

class DummyEcgController extends GetxController {
  var ecgData = <double>[].obs; // Observable list to hold ECG data
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startFetchingData();
  }

  void startFetchingData() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      // Simulate receiving new ECG data
      ecgData.add(generateRandomEcgValue());
      if (ecgData.length > 200) { // Keep only the latest 200 points
        ecgData.removeAt(0);
      }
    });
  }

  double generateRandomEcgValue() {
    // Replace this with actual ECG data fetching logic
    return (sin(DateTime.now().millisecondsSinceEpoch / 100.0) + 1) * 30; // Simulated value
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
