import 'dart:convert';

import 'package:country_codes/country_codes.dart';
import 'package:expenso/app/data/countries.dart';
import 'package:expenso/app/data/response_models/generate_otp_success_response.dart';
import 'package:expenso/app/network/XHttp.dart';
import 'package:expenso/app/network/endpoints.dart';
import 'package:expenso/app/widgets/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
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
      } else {
        Get.snackbar('title', 'message');
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
