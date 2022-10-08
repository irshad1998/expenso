import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import 'package:expenso/app/data/app_constants.dart';
import 'package:expenso/app/data/local_storage.dart';
import 'package:expenso/app/data/response_models/signup_otp_verification_response.dart';
import 'package:expenso/app/network/XHttp.dart';
import 'package:expenso/app/network/endpoints.dart';
import 'package:expenso/app/routes/app_pages.dart';
import 'package:expenso/app/widgets/custom_snackbar.dart';
import 'package:expenso/app/constants/strings.dart';

class OtpVerificationController extends GetxController {
  var mobile;
  var countryCode;
  var isSignup;

  final otpController = TextEditingController();

  void completeSignup() async {
    var _requestData = {
      'mobile': mobile,
      'countryCode': countryCode,
      'otp': otpController.text,
    };
    await XHttp.request(Endpoints.verifySignupOtp, data: _requestData, method: XHttp.POST).then((result) {
      if (result.success) {
        var data = OtpVerificationResponse.fromJson(jsonDecode(result.data));
        var token = data.data?.token;
        LocalStorage.instance.setValue(AppConstants.authenticationToken, token);
        LocalStorage.instance.setValue(AppConstants.isUserLoggedIn, true);
        SnackbarSuccess(titleText: 'Success!', messageText: data.message ?? Strings.signupSuccess).show();
        Get.offAllNamed(Routes.HOME);
      } else {
        var data = jsonDecode(result.data);
        SnackbarFailure(titleText: 'Error!', messageText: data['message']).show();
      }
    });
  }

  void completeLogin() async {
    var _requestData = {
      'mobile': mobile,
      'countryCode': countryCode,
      'otp': otpController.text,
    };
    await XHttp.request(Endpoints.login, method: XHttp.POST, data: _requestData).then((result) {
      if (result.success) {
        var data = OtpVerificationResponse.fromJson(jsonDecode(result.data));
        var token = data.data?.token;
        LocalStorage.instance.setValue(AppConstants.authenticationToken, token);
        LocalStorage.instance.setValue(AppConstants.isUserLoggedIn, true);
        SnackbarSuccess(titleText: 'Success!', messageText: data.message ?? Strings.loginSuccess).show();
        Get.offAllNamed(Routes.HOME);
      } else {
        var data = jsonDecode(result.data);
        SnackbarFailure(titleText: 'Error!', messageText: data['message']).show();
      }
    });
  }

  @override
  void onInit() {
    mobile = Get.arguments['requestData']['mobile'];
    countryCode = Get.arguments['requestData']['countryCode'];
    isSignup = Get.arguments['isSignup'];
    super.onInit();
  }
}
