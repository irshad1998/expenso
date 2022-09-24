import 'package:expenso/app/constants/colors.dart';
import 'package:expenso/app/constants/strings.dart';
import 'package:expenso/app/utilities/screen.dart';
import 'package:expenso/app/utilities/wawe.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.initialized;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildSplashBody(),
    );
  }

  Widget _buildSplashBody() {
    final height = Get.height;
    final width = Get.width;
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            TextWave(
              text: Strings.appName,
              waveColor: AppColors.primary,
              boxBackgroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 40.s, fontFamily: 'sans_bold'),
            ),
            Positioned(
              top: height * 0.518,
              right: width * 0.4,
              child: Text(
                Strings.appWord,
                style: TextStyle(
                    fontSize: 10.s, fontFamily: 'one_700', color: Colors.black),
              ),
            ),
            Positioned(
              bottom: height * 0.01,
              child: SpinKitFadingFour(
                color: AppColors.primary,
                size: 20.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
