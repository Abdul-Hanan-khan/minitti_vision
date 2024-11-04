import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test_flutter/src/controllers/connectivity_controller.dart';
import 'package:test_flutter/src/controllers/home_controller.dart';
import 'package:test_flutter/src/pages/blood_glucose_screen.dart';
import 'package:test_flutter/src/pages/blood_oxygen_screen.dart';
import 'package:test_flutter/src/pages/blood_pressure_screen.dart';
import 'package:test_flutter/src/pages/body_temperature.dart';
import 'package:test_flutter/src/pages/ecg_screen.dart';
import 'package:test_flutter/src/widget/battery_widget.dart';
import 'package:test_flutter/src/widget/hr_wave.dart';
import 'package:test_flutter/src/widget/messaging.dart';
import 'package:vibration/vibration.dart';
import '../../pages_data/health_data.dart';
import '../../widget/ecg_wave.dart';
import '../../widget/health_item.dart';
// import 'package:flutter_picker/flutter_picker.dart';

class HomePage extends StatefulWidget {
  var tabIndex;

  HomePage({super.key, required this.tabIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectivityController connectivity = Get.find();
  HomeController homeController = Get.find();

  // late BleData bleData;
  List<int>? selectIndex;

  // @override
  // void initState() {
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   // bleData.dispose();
  // }

  // showPickerArray(BuildContext context) {
  //   Picker(
  //       adapter: PickerDataAdapter<String>(
  //           pickerData: bleData.papers(), isArray: true),
  //       hideHeader: true,
  //       selecteds:selectIndex,
  //       title: const Text("Please Select"),
  //       onConfirm: (Picker picker, List value) {
  //         debugPrint("value= $value value[0]=${value[0]}");
  //         debugPrint("selected= ${picker.getSelectedValues()}");
  //         selectIndex=[value[0]];
  //         bleData.selectPaper(value[0]);
  //       }).showDialog(context);
  // }

  @override
  Widget build(BuildContext context) {

    if(connectivity.scanDes.value == "Disconnect"){
      homeController.checkAndMonitorBattery();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => connectivity.scanDes.value == "Disconnect"
                      ? ExternalDeviceBatteryWidget(
                          isCharging: homeController.isBatteryCharging.value,
                          batteryLevel: homeController.batteryLevel.value)
                      : Container()),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          if (connectivity.scanDes.value == "Connect") {
                            connectivity.blueToothManager.startScan();
                            connectivity.deviceList =
                                connectivity.blueToothManager.getDeviceList();
                            connectivity.isScan.value = true;
                            connectionDialog();
                          } else if (connectivity.scanDes.value ==
                              "Disconnect") {
                            connectivity.blueToothManager.disConnect();
                            // connectivity.blueToothManager.stopScan();
                            connectivity.scanDes.value = "Connect";
                            connectivity.isScan.value = false;

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Device Disconnected'),
                              backgroundColor: Colors.red,
                              duration: Duration(
                                  seconds:
                                      2), // how long the snackbar is visible
                            ));
                            Future.delayed(Duration(seconds: 1), () {
                              print("Stopping Scan");
                              connectivity.blueToothManager.stopScan();
                            });
                          }
                        },
                        child: Obx(() => Text(connectivity.scanDes.value))),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (connectivity.scanDes.value == "Disconnect") {
                        homeController.stopBatteryMonitor();
                        // means device is connected
                        Get.to(() => EcgScreen());
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Connect to Device",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            // timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Container(
                        height: 150,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 3,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 100,
                                child: Image.asset('assets/images/ecg.png')),
                            Text("ECG")
                          ],
                        )),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (connectivity.scanDes.value == "Disconnect") {
                        // means device is connected
                        homeController.stopBatteryMonitor();

                        Get.to(() => BloodPressureScreen());
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Connect to Device",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            // timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Container(
                      height: 150,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 3,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 90,
                              child: Image.asset(
                                  'assets/images/blood_pressure.png')),
                          Text("Blood Pressure")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (connectivity.scanDes.value == "Disconnect") {
                        // means device is connected
                        homeController.stopBatteryMonitor();

                        Get.to(() => BloodOxygenScreen());
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Connect to Device",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            // timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        // Messaging.showSnackBar(message: "Please Connect to Device", isSuccess: false);
                      }
                    },
                    child: Container(
                        height: 150,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 3,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 90,
                                width: 90,
                                child: Image.asset(
                                    'assets/images/blood_oxygen.png')),
                            Text("Blood Oxygen")
                          ],
                        )),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (connectivity.scanDes.value == "Disconnect") {
                        // means device is connected
                        homeController.stopBatteryMonitor();

                        Get.to(() => BloodGlucoseScreen());
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Connect to Device",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            // timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        // Messaging.showSnackBar(message: "Please Connect to Device", isSuccess: false);
                      }
                    },
                    child: Container(
                        height: 150,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 3,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 90,
                                child: Image.asset(
                                    'assets/images/blood_glucose.png')),
                            Text("Blood Glucose")
                          ],
                        )),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (connectivity.scanDes.value == "Disconnect") {
                        // means device is connected
                        homeController.stopBatteryMonitor();

                        Get.to(() => BodyTemperatureScreen());
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Connect to Device",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            // timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        // Messaging.showSnackBar(message: "Please Connect to Device", isSuccess: false);
                      }
                    },
                    child: Container(
                        height: 150,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 3,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 90,
                                child: Image.asset(
                                    'assets/images/body_temprature.png')),
                            Text("Body Temperature")
                          ],
                        )),
                  ),
                ),
              ],
            ),
            Obx(() => HealthItemWidget(
                data: "${homeController.bleData.battery} ",
                buttonTitle: "start Battery",
                onPressed: () {
                  homeController.checkAndMonitorBattery();

                  // homeController.bleData.startBattery();
                })),
            Obx(() => HealthItemWidget(
                data: "${homeController.bleData.temperature} ",
                buttonTitle: "start Temperature",
                onPressed: () {
                  homeController.bleData.startTemperature();
                })),
            Obx(() => HealthItemWidget(
                data:
                    "spo2: ${homeController.bleData.bloodOxygen}  hr:${homeController.bleData.heartRate} ",
                buttonTitle: "start Blood oxygen",
                onPressed: () {
                  homeController.bleData.startBloodOxygen();
                })),
            HealthItemWidget(
                data: "",
                buttonTitle: "stop Blood oxygen",
                onPressed: () {
                  homeController.bleData.stopBloodOxygen();
                }),
            HealthItemWidget(
                data: "",
                buttonTitle: "select Blood Glucose paper",
                onPressed: () {
                  // showPickerArray(context);
                }),
            Obx(() => HealthItemWidget(
                data: "${homeController.bleData.bloodGlucose}  ",
                buttonTitle: "start Blood Glucose",
                onPressed: () {
                  homeController.bleData.startBloodGlucose();
                })),
            HealthItemWidget(
                data: "",
                buttonTitle: "stop Blood Glucose",
                onPressed: () {
                  homeController.bleData.stopBloodGlucose();
                }),
            Obx(() => HealthItemWidget(
                data: "${homeController.bleData.bloodPressure}",
                buttonTitle: "start Blood Pressure",
                onPressed: () {
                  homeController.bleData.startBloodPressure();
                })),
            HealthItemWidget(
                data: "",
                buttonTitle: "stop Blood Pressure",
                onPressed: () {
                  homeController.bleData.stopBloodPressure();
                }),
            Container(
              height: 200,
              color: Colors.orange.withOpacity(0.1),
              child: HrWave(
                  waveData: homeController.bleData.hrWaveList,
                  update: homeController.bleData.hrWaveUpdate,
                  paintColor: 0xFFFF9000),
            ),
            Obx(() => HealthItemWidget(
                data: "${homeController.bleData.outEcgValue} ",
                buttonTitle: "start Ecg",
                onPressed: () {
                  homeController.bleData.startEcg();
                })),
            HealthItemWidget(
                data: " ",
                buttonTitle: "Stop Ecg",
                onPressed: () {
                  homeController.bleData.stopEcg();
                }),
            EcgWave(homeController.bleData.waveData,
                homeController.bleData.ecgUpdate),
          ],
        ),
      ),
    );
  }

  connectionDialog() {
    showDialog(

        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text("Available Device are "),
            content: SizedBox(
              width: Get.width,
              height: 300,
              child: Obx(() => Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          connectivity.deviceList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: connectivity.deviceList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    ScanResult result =
                                        connectivity.deviceList[index];
                                    return TextButton(
                                      onPressed: () async {
                                        try {
                                          EasyLoading.show(
                                              status: 'Connecting...');
                                          await connectivity.blueToothManager
                                              .stopScan();
                                          debugPrint(
                                              " connect element=${result.runtimeType}");
                                          await Future.delayed(const Duration(
                                              milliseconds: 1000));
                                          await connectivity.blueToothManager
                                              .connect(result.device);
                                          connectivity.blueToothManager
                                              .setDeviceName(result
                                                  .advertisementData.localName);
                                          connectivity.scanDes.value =
                                              "Disconnect";
                                          await Future.delayed(
                                              Duration(seconds: 1), () async {

                                            Fluttertoast.showToast(
                                                msg: "Connected To Device",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                // timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0);


                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Connected to Device Successfully'),
                                            //         backgroundColor: Colors.green,
                                            //         duration: Duration(seconds: 2)));


                                            await Future.delayed(
                                                Duration(seconds: 0));
                                            // homeController.bleData.startBattery();
                                            homeController.checkAndMonitorBattery();
                                            if (await Vibration.hasVibrator() ?? false) {
                                              Vibration.vibrate(duration: 500); // Vibrate for 0.5s on button press
                                            }
                                          });
                                          Get.back();
                                        } catch (e) {
                                          connectivity.scanDes.value =
                                              "Connect";
                                          await Future.delayed(
                                              Duration(seconds: 0), () {
                                            Fluttertoast.showToast(
                                                msg: "Please Connect to Device",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                // timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);

                                            // ScaffoldMessenger.of(context)
                                                // .showSnackBar(SnackBar(
                                                //     content: Text(
                                                //         'Failed to Connect'),
                                                //     backgroundColor: Colors.red,
                                                //     duration:
                                                //         Duration(seconds: 2)));
                                          });
                                          Get.back();
                                        }
                                      },
                                      child: SingleChildScrollView(
                                        physics: const ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                            "DeviceName:${result.advertisementData.localName} "),
                                      ),
                                    );
                                  })
                              : Container(),
                          TextButton(
                            onPressed: connectivity.scanDes.value != "Connect"
                                ? null
                                : () {
                                    connectivity.blueToothManager.startScan();
                                    connectivity.deviceList = connectivity
                                        .blueToothManager
                                        .getDeviceList();
                                    connectivity.isScan.value = true;
                                  },
                            child: Text(connectivity.scanDes.value == "Connect"
                                ? "Scan Again"
                                : "Scanning"),
                          ),
                          connectivity.scanDes.value == "Scanning"
                              ? CupertinoActivityIndicator()
                              : Container()
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            connectivity.blueToothManager.stopScan();
                            connectivity.scanDes.value = "Connect";
                            Get.back();
                          },
                          child: Text("Cancel"))
                    ],
                  )),
            ),
          );
        });
  }
}
