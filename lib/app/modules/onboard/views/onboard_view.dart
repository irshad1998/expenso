import 'package:expenso/app/constants/colors.dart';
import 'package:expenso/app/constants/dimens.dart';
import 'package:expenso/app/constants/strings.dart';
import 'package:expenso/app/utilities/screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboard_controller.dart';

class OnboardView extends GetView<OnboardController> {
  @override
  Widget build(BuildContext context) {
    print(height);
    print(width);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _buildTittleBar(),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.07),
                    child: _buildPageView(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.5, color: AppColors.primary),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: SmoothPageIndicator(
                      controller: controller.pageController,
                      count: 3,
                      axisDirection: Axis.horizontal,
                      effect: SlideEffect(
                          spacing: 8.0,
                          radius: 4.0,
                          dotWidth: 24.0,
                          dotHeight: 16.0,
                          paintStyle: PaintingStyle.stroke,
                          strokeWidth: 1.5,
                          dotColor: Colors.transparent,
                          activeDotColor: AppColors.primary),
                    ),
                  )
                ],
              ),
              _buildBottom()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTittleBar() {
    return Container(
      width: width,
      height: height * 0.08,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              Strings.appName,
              style: TextStyle(
                  fontSize: 22.s,
                  fontFamily: 'sans_bold',
                  color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: width,
        height: height * 0.65,
        // color: Colors.red,
        child: PageView(
          controller: controller.pageController,
          onPageChanged: (value) => controller.onPageChanged(value),
          children: [
            _OnboardItem(
              title: 'Smart Expense Tracker',
              text:
                  'Expenso makes managing personal finances as easy as pie! Now easily record your personal and business financial transactions',
            ),
            _OnboardItem(
              title: 'Smart Statistics',
              text:
                  'Dive into weekly reports and charts, plan your shopping, and share specific features and data with loved ones with Expenso',
            ),
            _OnboardItem(
              title: 'Expenso Secure+',
              text:
                  'Expenso secure is a high secure credential manager. You can store your credential with Expenso secure for easy access',
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => controller.done(),
              child: Text('Skip',
                  style: TextStyle(
                      fontFamily: 'sans_bold', color: AppColors.primary)),
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16)),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.green.withOpacity(0.1),
                  onTap: () => controller.pageController.page?.toInt() == 2
                      ? controller.done()
                      : controller.nextPage(),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.5, color: AppColors.primary),
                        // color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 6),
                      child: Obx(
                        () => Text(
                          controller.actionButtonText.value,
                          style: TextStyle(
                              fontFamily: 'sans_bold',
                              color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardItem extends StatelessWidget {
  const _OnboardItem({super.key, required this.text, required this.title});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height * 0.7,
      child: Column(
        children: [
          Container(
            width: width,
            height: height * 0.5,
            // color: Colors.blue,
          ),
          SizedBox(
            width: width,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontFamily: 'sans_bold'),
            ),
          ),
          SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style:
                TextStyle(fontFamily: 'one_700', color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
