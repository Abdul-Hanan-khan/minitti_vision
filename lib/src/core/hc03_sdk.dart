// ignore_for_file: constant_identifier_names

import 'dart:typed_data';

import 'package:test_flutter/src/core/common/baseCommon.dart';
import 'package:test_flutter/src/core/hc03_sdk_impl.dart';
import 'package:test_flutter/src/core/health/ox/lib/models/OxWave.dart';

abstract class Hc03Sdk {
  Hc03Sdk();
  Uint8List startDetect(Detection detect);
  Uint8List stopDetect(Detection detect);
  void parseData(List<int> data);
  Future<Hc03BaseMeasurementData> getTemperature();
  Future<Hc03BaseMeasurementData> getBattery();
  Future<
      ({
        Stream<Hc03BaseMeasurementData> data,
        Stream<Hc03BaseMeasurementData> stop,
      })> getBloodOxygen();
  Stream<Hc03BaseMeasurementData> getBloodGlucoseData();
  Stream<Hc03BaseMeasurementData> getBloodPressureData();
  Stream<Hc03BaseMeasurementData> getEcgData();
  void setTestPaperModel(int index);
  factory Hc03Sdk.getInstance() => Hc03SdkImpl();
}

abstract class Hc03BaseModel {}

abstract class Hc03BaseMeasurementData extends Hc03BaseModel {}

class TemperatureData extends Hc03BaseMeasurementData {
  final double temperature;
  TemperatureData(this.temperature);
}

class BloodOxygenData extends Hc03BaseMeasurementData {
  final int bloodOxygen;
  final int heartRate;
  BloodOxygenData(this.bloodOxygen, this.heartRate);
}

class BloodOxygenWaveData extends Hc03BaseMeasurementData {
  final OxWave red;
  final OxWave ir;
  BloodOxygenWaveData(this.red, this.ir);
}

class FingerDetection extends Hc03BaseMeasurementData {
  final bool isTouch;
  FingerDetection(this.isTouch);
}

class StopMeasure extends Hc03BaseMeasurementData {
  StopMeasure();
}

class BloodGlucoseSendData extends Hc03BaseMeasurementData {
  final Uint8List sendList;
  BloodGlucoseSendData(this.sendList);
}

class BloodGlucosePaperState extends Hc03BaseMeasurementData {
  final int code;
  final String message;
  BloodGlucosePaperState(this.code, this.message);
}

class BloodGlucosePaperData extends Hc03BaseMeasurementData {
  final dynamic data;
  BloodGlucosePaperData(this.data);
}

class BloodPressureSendData extends Hc03BaseMeasurementData {
  final Uint8List sendList;
  BloodPressureSendData(this.sendList);
}

class BloodPressureProcess extends Hc03BaseMeasurementData {
  final Process process;
  BloodPressureProcess(this.process);
}

class BloodPressureResult extends Hc03BaseMeasurementData {
  int pd;
  int ps;
  int hr;
  BloodPressureResult(this.ps, this.pd, this.hr);
}

class BatteryLevelData extends Hc03BaseMeasurementData {
  final int batteryLevel;
  BatteryLevelData(this.batteryLevel);
}

class BatteryChargingStatus extends Hc03BaseMeasurementData {
  final bool batteryCharging;
  final String batteryLevel;
  BatteryChargingStatus(this.batteryCharging,this.batteryLevel);
}


class EcgData extends Hc03BaseMeasurementData{
  Map ecg;
  EcgData(this.ecg);
}

enum Detection { BT, OX, ECG, BG, BP, BATTERY }
