import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:expenso/app/constants/colors.dart';
import 'package:expenso/app/constants/dimens.dart';
import 'package:expenso/app/constants/strings.dart';
import 'package:expenso/app/routes/app_pages.dart';
import 'package:expenso/app/utilities/screen.dart';
import 'package:expenso/app/widgets/country_picker.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    controller.initialized;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'E',
                        style: TextStyle(fontSize: 80),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: Text(
                        Strings.welcomeBack,
                        style: TextStyle(fontSize: 30.s, fontFamily: 'sans_bold'),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: Text(
                        Strings.loginToContinue,
                        style: TextStyle(fontSize: 18.s, fontFamily: 'one_700', color: Colors.black54),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Row(
                      children: [
                        Obx(
                          () => CountryPicker(
                            initialCountry: controller.initialCountry.value,
                            onSelect: (country) => controller.setCountry(country),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Obx(
                            () => TextField(
                              controller: controller.mobileTextEditingController,
                              style: TextStyle(fontSize: 18, fontFamily: 'one_700', letterSpacing: 1),
                              keyboardType: TextInputType.phone,
                              cursorColor: AppColors.primary,
                              decoration: InputDecoration(
                                hintText: Strings.mobileNumber,
                                prefixIcon: SizedBox(
                                  width: 50,
                                  height: 49,
                                  child: Center(
                                    child: Text(
                                      '+${controller.initialCountryCode.value}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'one_700',
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.primary, width: 0.5)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.primary, width: 1)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(Strings.or),
                          ),
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset('assets/svgs/google.svg'),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(width: 0.5, color: Colors.grey)),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 50,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Image.asset('assets/images/more.png'),
                          ),
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 0.5, color: Colors.grey)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: Strings.dontHaveAccount,
                      style: TextStyle(fontSize: 12.s, fontFamily: 'one_400', color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: Strings.register,
                          style: TextStyle(fontSize: 14.s, fontFamily: 'one_700', color: Colors.blue),
                          recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.SIGNUP),
                        ),
                        TextSpan(
                          text: Strings.here,
                          style: TextStyle(fontSize: 12.s, fontFamily: 'one_400', color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Material(
                    color: AppColors.primary,
                    child: InkWell(
                      highlightColor: Colors.white,
                      // onTap: () => controller.generateOtpForLogin(),
                      child: Container(
                        width: width,
                        height: 54.h,
                        child: Center(
                          child: Text(
                            Strings.continueCaps,
                            style: TextStyle(fontFamily: 'sans_bold', color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EditText extends StatelessWidget {
  const EditText({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        labelStyle: TextStyle(fontSize: 14.s, color: Colors.black.withOpacity(0.5)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
