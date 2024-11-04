import 'package:test_flutter/src/pages/tabs/bluepage.dart';
import 'package:test_flutter/src/pages/tabs/home_page.dart';

import '../pages/tabs/tab.dart';
import 'package:get/get.dart';

var Pages = [
  GetPage(name: "/", page: () => HomePage(tabIndex: 1,)),
  // GetPage(name: "/", page: () => BluePage(tabIndex: 0,)),
];


