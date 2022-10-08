import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

import 'package:expenso/app/constants/colors.dart';
import 'package:expenso/app/constants/dimens.dart';
import 'package:expenso/app/constants/strings.dart';
import 'package:expenso/app/utilities/screen.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(''),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // SizedBox(width: width, height: height * 0.05),
                Container(
                  width: width * 0.7,
                  height: height * 0.3,
                  child: Lottie.asset(
                    'assets/json/otp_verify.json',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  Strings.otpVerification,
                  style: TextStyle(fontSize: 18.s, fontFamily: 'sans_bold'),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: Strings.otpSentTo,
                    style: TextStyle(fontSize: 12.s, fontFamily: 'one_400', color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' +91-9744477794',
                        style: TextStyle(fontSize: 14.s, fontFamily: 'one_700', color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Pinput(
                  controller: controller.otpController,
                  length: 4,
                  defaultPinTheme: PinTheme(
                    textStyle: TextStyle(fontSize: 28.s, fontFamily: 'one_700'),
                    width: 55.w,
                    height: 55.w,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(117, 214, 221, 222),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Obx(
                  () => RichText(
                    text: TextSpan(
                      text: Strings.didntRecOtp,
                      style: TextStyle(fontSize: 12.s, fontFamily: 'one_400', color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: !controller.isResendButtonDisabled.value
                              ? '00:${controller.secondsRemaining.value > 9 ? controller.secondsRemaining.value : '0${controller.secondsRemaining.value}'}'
                              : Strings.resendOtp,
                          style: TextStyle(
                              fontSize: 14.s,
                              fontFamily: !controller.isResendButtonDisabled.value ? 'one_400' : 'one_700',
                              color: !controller.isResendButtonDisabled.value ? Colors.grey.shade500 : Colors.blue),
                          recognizer: TapGestureRecognizer()..onTap = () => controller.resendOtp(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Material(
                  color: AppColors.primary,
                  child: InkWell(
                    highlightColor: Colors.white,
                    onTap: controller.isSignup ? () => controller.completeSignup() : () => controller.completeLogin(),
                    child: Container(
                      width: width,
                      height: 54.h,
                      child: Center(
                        child: Text(
                          Strings.verifyAndProceed,
                          style: TextStyle(fontFamily: 'sans_bold', color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
