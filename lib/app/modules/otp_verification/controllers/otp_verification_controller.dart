import 'dart:convert';
import 'dart:async';

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

  late Timer _timer;
  var secondsRemaining = 30.obs;
  var isResendButtonDisabled = true.obs;

  void startTimer() {
    isResendButtonDisabled.value = false;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value = secondsRemaining.value - 1;
        } else {
          _timer.cancel();
          isResendButtonDisabled.value = true;
        }
      },
    );
  }

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

  void resendOtp() async {
    secondsRemaining.value = 30;
    var _requestData = {'countryCode': countryCode, 'mobile': mobile};
    if (isSignup) {
      await XHttp.request(Endpoints.generateSignupOtp, data: _requestData, method: XHttp.POST).then((result) {
        if (result.success) {
          startTimer();
          SnackbarSuccess(titleText: 'OTP Generated', messageText: 'OTP send to your mobile number').show();
        } else {
          SnackbarFailure(titleText: 'Error', messageText: 'Something wen\'t wrong').show();
        }
      });
    } else {
      await XHttp.request(Endpoints.login, method: XHttp.POST, data: _requestData).then((result) {
        if (result.success) {
          startTimer();
          SnackbarSuccess(titleText: 'OTP Generated', messageText: 'OTP send to your mobile number').show();
        } else {
          SnackbarFailure(titleText: 'Error', messageText: 'Something wen\'t wrong').show();
        }
      });
    }
  }

  @override
  void onInit() {
    startTimer();
    mobile = Get.arguments['requestData']['mobile'];
    countryCode = Get.arguments['requestData']['countryCode'];
    isSignup = Get.arguments['isSignup'];
    super.onInit();
  }
}
