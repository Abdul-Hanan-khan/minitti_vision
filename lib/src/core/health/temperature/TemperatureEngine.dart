

import 'package:test_flutter/src/core/engine/Engine.dart';
import 'package:test_flutter/src/core/health/temperature/lib/Tmeperature.dart';

class TemperatureEngine extends Engine {
  @override
  void run(List<int> data) {
    Temperature().dealData(data);
  }
}