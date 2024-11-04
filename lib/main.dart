import 'package:flutter/material.dart';
import 'package:test_flutter/src/controllers/connectivity_controller.dart';
import './src/routers/router.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'src/controllers/home_controller.dart';
void main() {
  runApp(const MyApp());
  Get.put(HomeController());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hc03 Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      // home: CustomLoader(),
      initialRoute: "/",
      getPages: Pages,
      builder: EasyLoading.init(),
    );
  }
}
