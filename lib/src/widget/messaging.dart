

import 'package:flutter/material.dart';


class Messaging {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
  GlobalKey<ScaffoldMessengerState>();






  static void showInfoDialog(
      {required BuildContext context, required Widget content}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return content;
      },
    );
  }
}