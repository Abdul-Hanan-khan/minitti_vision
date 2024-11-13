import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_flutter/src/bluetooth/bluetooth_manager.dart';
import 'package:test_flutter/src/common/constant.dart';
import 'package:test_flutter/src/core/hc03_sdk.dart';
import 'package:test_flutter/src/core/protocol/Exception.dart';

///Core code call
class BleData {
  //ecg
  List<int> waveData = [];
  var ecgUpdate = false.obs;
  var maxRR = 0.obs;
  var minRR = 0.obs;
  var hr = 0.obs;
  var hrv = 0.obs;
  var mood = 0.obs;
  var respiratoryRateV = 0.obs;
  var isTouch = false.obs;
  var outEcgValue = "".obs;
  var temperature = 0.0.obs;
  var bloodOxygen = 0.obs;
  var heartRate = 0.obs;
  var measuringBloodOxygen = false.obs;
  var hrWaveList = <int>[];
  var hrWaveUpdate = false.obs;
  var bloodGlucose = "".obs;
  var bloodPressure = "".obs;
  var battery = "0".obs;
  var myBpResponse = Rxn();
  var myBatteryResponse = Rxn();
  var temperatureData = Rxn();
  var measuringEcg = false.obs;
  var ecgSeconds = 0.obs;  // Observable to track seconds
  // var ecgMinutes = 0.obs;
   Timer? _ecgTimer;


  //bluetooth
  late BlueToothManager blueToothManager;

  //blood pressure
  static final BleData _instance = BleData._internal();

  // var channel =
  //     const BasicMessageChannel('ecgMessageChannel', StandardMessageCodec());

  late Hc03Sdk sdk;

  StreamSubscription<Hc03BaseMeasurementData>? streamSubscription;

  factory BleData() {
    return _instance;
  }

  BleData._internal();

  void init() async {
    sdk = Hc03Sdk.getInstance();

    ///ECG data channel
    final ecgStream = sdk.getEcgData();
    ecgStream.listen((data) {
      if (data is EcgData) {
        var message = data.ecg;
        switch (message["type"]) {
          case "wave":
            waveData.add(message["data"] as int);
            if (waveData.length > 2200) {
              waveData.removeAt(0);
            }
            ecgUpdate.value = !ecgUpdate.value;
            break;
          case "HR":
            hr.value = message["value"];
            break;
          case "Mood Index":
            if (hrv.value != 0) {
              stopEcg();

            }
            mood.value = message["value"];
            break;
          case "RR":
            if (message["value"] > maxRR.value) {
              maxRR.value = message["value"];
            } else if (message["value"] < minRR.value &&
                message["value"] > 300) {
              minRR.value = message["value"];
            } else if (minRR.value == 0 && message["value"] > 300) {
              minRR.value = message["value"];
            }
            break;
          case "HRV":
            if (mood.value != 0) {
              stopEcg();
            }
            hrv.value = message["value"];
            break;
          case "RESPIRATORY RATE":
            respiratoryRateV.value = message["value"];
            break;
          case "touch":
            isTouch.value = message["isTouch"];
            debugPrint(
                '================= isTouch  isTouch.value=${isTouch.value}');
            if (!isTouch.value) {
              showToast("Please place your fingers correctly on the device");
            }
            break;
        }
        outEcgValue.value = "hr=$hr hrv=$hrv  mood=$mood  respiratoryRate=$respiratoryRateV minRR=$minRR maxRR=$maxRR";

      }
    });



    /// get blood oxygen data
    final stream = await sdk.getBloodOxygen();
    streamSubscription = stream.data.listen((Hc03BaseMeasurementData data) {
      if (data is BloodOxygenData) {
        bloodOxygen.value = data.bloodOxygen;
        heartRate.value = data.heartRate;

      } else if (data is FingerDetection) {
        debugPrint("fingerDetection=${data.isTouch}");
      } else if (data is BloodOxygenWaveData) {
        hrWaveList.add(data.red.wave.toInt());
        if (hrWaveList.length > 400) {
          hrWaveList.removeAt(0);
        }
        hrWaveUpdate.value = !hrWaveUpdate.value;
      }
    }, onError: (Object error, StackTrace stackTrace) {
      if (error is AppException) {
        debugPrint("getTemperature exception=${error.message}");
        measuringBloodOxygen.value = false;

      }
    });
    stream.stop.listen((Hc03BaseMeasurementData data) {
      if (data is StopMeasure) {
        print("Auto Stop Blood Oxygen");
        measuringBloodOxygen.value = false;

        stopBloodOxygen();
        measuringBloodOxygen.value = false;

      }
    });

    /// get blood glucose data
    sdk.getBloodGlucoseData().listen((data) {
      if (data is BloodGlucoseSendData) {
        sendCmd(data.sendList);
      } else if (data is BloodGlucosePaperState) {
        bloodGlucose.value = data.message;
      } else if (data is BloodGlucosePaperData) {
        bloodGlucose.value = "blood glucose: ${data.data} ";
      }
    });

    /// get blood pressure data
    sdk.getBloodPressureData().listen((data) {
      if (data is BloodPressureSendData) {
        sendCmd(data.sendList);
      } else if (data is BloodPressureProcess) {
        debugPrint("BloodPressureProcess=${data.process}");
      } else if (data is BloodPressureResult) {
        bloodPressure.value = "SystolicBloodPressure:${data.ps}mmHg DiastolicBloodPressure:${data.pd}mmHg hr:${data.hr}times/minute";
        debugPrint(
            "BloodPressureResult ps=${data.ps} pd=${data.pd} hr=${data.hr}");
        myBpResponse.value = BloodPressureResult(data.ps, data.pd, data.hr);

      }
    }, onError: (Object error, StackTrace stackTrace) {
      if (error is AppException) {
        debugPrint("getBloodPressureData exception=${error.message}");
        bloodPressure.value = error.message;
        myBpResponse.value = AppException(message: error.message, type: error.type);
      }
    });

    blueToothManager = BlueToothManager();

    /// init bluetooth notifity listener
    blueToothManager.notifityWriteListener(NOTIFY_UUID, (data) async {
      sdk.parseData(data);
    }, onError: (error) {
      debugPrint("notifityWriteListener error=$error");
    });
  }

  void dispose() {
    streamSubscription?.cancel();
  }

  void sendCmd(Uint8List data) async {
    await blueToothManager.write(WRITE_UUID, data.toList());
  }

  /// start detect
  void startDetect(Detection detection) async {
    var data = sdk.startDetect(detection);
    await blueToothManager.write(WRITE_UUID, data.toList());
  }

  /// stop detect
  void stopDetect(Detection detection) async {
    var data = sdk.stopDetect(detection);
    await blueToothManager.write(WRITE_UUID, data.toList());
  }

  /// start blood oxygen data
  void startBloodOxygen() {
    hrWaveList.clear();
    startDetect(Detection.OX);
  }

  /// stop blood oxygen data
  void stopBloodOxygen() {
    stopDetect(Detection.OX);
  }

  /// start blood glucose data
  void startBloodGlucose() {
    startDetect(Detection.BG);
  }

  /// stop blood glucose data
  void stopBloodGlucose() {
    stopDetect(Detection.BG);
  }

  /// start blood glucose data
  void startBloodPressure() {
    startDetect(Detection.BP);
  }

  /// stop blood glucose data
  void stopBloodPressure() {
    stopDetect(Detection.BP);
  }

  void selectPaper(int index) {
    sdk.setTestPaperModel(index);
  }

  ///get battery
  Future<bool> startBattery() async{
    bool batteryDataLoaded = false;
    startDetect(Detection.BATTERY);
    sdk.getBattery().then((data) {
      if (data is BatteryLevelData) {
        myBatteryResponse.value = data;
        batteryDataLoaded = true;
        battery.value = "battery: ${data.batteryLevel}%";
      } else if (data is BatteryChargingStatus) {
        batteryDataLoaded = true;
        myBatteryResponse.value = data;
        battery.value = data.batteryCharging ? "charging" : "unCharging";
      }
    });
    return batteryDataLoaded;
  }

  /// get temperature data
  void startTemperature() {
    startDetect(Detection.BT);
    sdk.getTemperature().then((Hc03BaseMeasurementData data) {
      if (data is TemperatureData) {
        temperature.value = data.temperature;
        temperatureData.value = data;
      }
    }).catchError((error) {
      if (error is AppException) {
        temperatureData.value = error;
        debugPrint("getTemperature exception=${error.message}");
      }
    });
  }

  void stopTemperature() {
    stopDetect(Detection.BT);
  }

  void clearEcgReadings(){
    mood.value = 0;
    hr.value = 0;
    maxRR.value = 0;
    minRR.value = 0;
    hrv.value = 0;
    respiratoryRateV.value = 0;
    // ecgMinutes.value=0;
    ecgSeconds.value=0;
    waveData.clear();



  }

  void startEcg() async {
    clearEcgReadings();
    startTimerEcg();
    startDetect(Detection.ECG);
  }

  void stopEcg() async {
    stopTimerEcg();
    stopDetect(Detection.ECG);
    measuringEcg.value = false;
  }

  startTimerEcg(){
    final NumberFormat formatter = NumberFormat('00');
    _ecgTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
     ecgSeconds.value =  int.parse(formatter.format(ecgSeconds.value+1));
      if (ecgSeconds.value >= 60) {
        stopEcg();
        // ecgMinutes.value= int.parse(formatter.format(ecgMinutes.value+1));
        // ecgSeconds.value = int.parse(formatter.format(0)); // Reset seconds to 0 after a minute
      }
    });
  }

  stopTimerEcg(){
    if(_ecgTimer != null){
      _ecgTimer!.cancel();

    }
  }
  void showToast(String content) {
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  List<List<String>> papers() {
    List<String> paper = [];
    List<List<String>> result = [];
    for (int i = 0; i <= 35; i++) {
      if (i < 10) {
        paper.add("C0$i");
      } else {
        paper.add("C$i");
      }
    }
    debugPrint("paper=$paper");
    result.add(paper);
    return result;
  }
}
