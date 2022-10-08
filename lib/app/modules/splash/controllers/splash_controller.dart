import 'dart:async';

import 'package:get/get.dart';

import 'package:expenso/app/data/app_constants.dart';
import 'package:expenso/app/data/local_storage.dart';
import 'package:expenso/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final _splashDuration = const Duration(seconds: 3);

  void navigate() async {
    var onBoardIsDone = LocalStorage.instance.getValue(AppConstants.onboardIsDone);
    if (onBoardIsDone != null && onBoardIsDone) {
      var userToken = LocalStorage.instance.getValue(AppConstants.authenticationToken);
      if (userToken != null) {
        Timer(_splashDuration, () => Get.offNamed(Routes.HOME));
      } else {
        Timer(_splashDuration, () => Get.offNamed(Routes.LOGIN));
      }
    } else {
      Timer(_splashDuration, () => Get.offNamed(Routes.ONBOARD));
    }
  }

  @override
  void onInit() {
    super.onInit();
    navigate();
  }
}
