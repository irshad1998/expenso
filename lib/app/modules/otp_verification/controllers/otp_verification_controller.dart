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
        var data = SignupOtpVerificationResponse.fromJson(jsonDecode(result.data));
        var token = data.data?.token;
        LocalStorage.instance.setValue(AppConstants.authenticationToken, token);
        SnackbarSuccess(titleText: 'Success!', messageText: data.message ?? 'Signup successful').show();
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
