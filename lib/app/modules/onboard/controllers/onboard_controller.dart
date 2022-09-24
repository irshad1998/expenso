import 'package:expenso/app/data/app_constants.dart';
import 'package:expenso/app/data/local_storage.dart';
import 'package:expenso/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnboardController extends GetxController {
  final actionButtonText = 'Next'.obs;
  PageController pageController = PageController();

  void nextPage() {
    pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    if (pageController.page?.toInt() == 1 ||
        pageController.page?.toInt() == 2) {
      actionButtonText.value = 'Done';
    } else {
      actionButtonText.value = 'Next';
    }
  }

  void onPageChanged(int value) {
    if (value == 2) {
      actionButtonText.value = 'Done';
    } else {
      actionButtonText.value = 'Next';
    }
  }

  void done() {
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    LocalStorage.instance.setValue(AppConstants.onboardIsDone, true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
