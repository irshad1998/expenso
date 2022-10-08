import 'package:expenso/app/constants/colors.dart';
import 'package:expenso/app/utilities/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarSuccess {
  final String titleText;
  final String messageText;
  final IconData icon;

  SnackbarSuccess({
    required this.titleText,
    required this.messageText,
    this.icon = Icons.check_circle,
  });

  show() {
    Get.snackbar("", "",
        titleText: Text(
          titleText,
          style: TextStyle(fontSize: 16.s, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'one_700'),
        ),
        messageText: Text(
          messageText,
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'one_400'),
        ),
        icon: Icon(
          icon,
          color: Color.fromARGB(255, 15, 255, 119),
        ),
        backgroundColor: Color.fromARGB(255, 15, 255, 119).withOpacity(0.2),
        colorText: Color.fromARGB(255, 15, 255, 119),
        snackPosition: SnackPosition.TOP);
    margin:
    const EdgeInsets.only(top: 24.0);
  }
}

class SnackbarFailure {
  final String titleText;
  final String messageText;
  final IconData icon;

  SnackbarFailure({
    required this.titleText,
    required this.messageText,
    this.icon = Icons.check_circle,
  });

  show() {
    Get.snackbar("", "",
        titleText: Text(
          titleText,
          style: TextStyle(fontSize: 16.s, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'one_700'),
        ),
        messageText: Text(
          messageText,
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'one_400'),
        ),
        icon: Icon(
          icon,
          color: Color.fromARGB(255, 255, 17, 0),
        ),
        backgroundColor: Color.fromARGB(255, 255, 17, 0).withOpacity(0.2),
        colorText: Color.fromARGB(255, 255, 17, 0),
        snackPosition: SnackPosition.TOP);
    margin:
    const EdgeInsets.only(top: 24.0);
  }
}
