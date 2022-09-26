import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:expenso/app/data/countries.dart';
import 'package:expenso/app/data/response_models/exist_otp_response.dart';
import 'package:expenso/app/data/response_models/generate_otp_success_response.dart';
import 'package:expenso/app/network/XHttp.dart';
import 'package:expenso/app/network/endpoints.dart';
import 'package:expenso/app/routes/app_pages.dart';
import 'package:expenso/app/widgets/country_picker.dart';
import 'package:expenso/app/widgets/custom_snackbar.dart';

class SignupController extends GetxController {
  final initialCountry = 'in'.obs;
  final initialCountryCode = '91'.obs;

  void setCountry(Country country) {
    initialCountry.value = country.code;
    initialCountryCode.value = country.dialCode;
  }

  final mobileTextEditingController = TextEditingController();

  void generateOtpForLogin() async {
    var _requestData = {'mobile': mobileTextEditingController.text, 'countryCode': '+${initialCountryCode}'};
    await XHttp.request(Endpoints.generateSignupOtp, data: _requestData, method: XHttp.POST).then((result) {
      if (result.success) {
        var data = GenerateOtpSuccessResponse.fromJson(jsonDecode(result.data));
        SnackbarSuccess(
          titleText: 'Success!',
          messageText: data.data?.otp ?? '',
        ).show();
        Get.toNamed(Routes.OTP_VERIFICATION,
            arguments: {'isSignup': true, 'requestData': _requestData, 'otp': data.data?.otp});
      } else {
        var data = ExistOtpResponse.fromJson(jsonDecode(result.data));
        SnackbarFailure(
          titleText: 'Error!',
          messageText: data.message ?? '',
        ).show();
      }
    });
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
