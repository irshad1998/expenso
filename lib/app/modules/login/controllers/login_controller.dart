import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:expenso/app/constants/strings.dart';
import 'package:expenso/app/data/response_models/login_mobile_generate_otp_failure_response.dart';
import 'package:expenso/app/data/response_models/login_mobile_generate_otp_success_response.dart';
import 'package:expenso/app/network/XHttp.dart';
import 'package:expenso/app/network/endpoints.dart';
import 'package:expenso/app/routes/app_pages.dart';
import 'package:expenso/app/widgets/custom_snackbar.dart';
import 'package:expenso/app/data/countries.dart';
import 'package:expenso/app/widgets/country_picker.dart';

class LoginController extends GetxController {
  final initialCountry = 'in'.obs;
  final initialCountryCode = '91'.obs;
  final phoneNumberLength = 10.obs;

  void setCountry(Country country) {
    initialCountry.value = country.code;
    initialCountryCode.value = country.dialCode;
    phoneNumberLength.value = country.maxLength;
  }

  final mobileTextEditingController = TextEditingController();

  void requestOtp() async {
    var _requestData = {
      'countryCode': '+$initialCountryCode',
      'mobile': mobileTextEditingController.text,
    };
    if (mobileTextEditingController.text.length == phoneNumberLength.value) {
      await XHttp.request(Endpoints.login, method: XHttp.POST, data: _requestData).then(
        (result) {
          if (result.success) {
            var data = LoginMobileGenerateOtpSuccessResponse.fromJson(jsonDecode(result.data));
            Get.toNamed(Routes.OTP_VERIFICATION, arguments: {
              'isSignup': false,
              'requestData': _requestData,
              'otp': data.data?.otp,
            });
          } else {
            var data = LoginMobileGenerateOtpFailureResponse.fromJson(jsonDecode(result.data));
            SnackbarFailure(
                    titleText: Strings.otpAlreadySent, messageText: data.message ?? Strings.pleaseTryAfter30Seconds)
                .show();
          }
        },
      );
    } else {
      SnackbarFailure(titleText: 'Error!', messageText: Strings.invalidPhoneNumber).show();
    }
  }

  @override
  void onInit() {
    super.onInit();
    Get.put(CountryPickerController());
  }

  @override
  void dispose() {
    Get.delete<CountryPickerController>(force: true);
    super.dispose();
  }
}
