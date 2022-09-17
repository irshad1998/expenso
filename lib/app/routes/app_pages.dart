import 'package:get/get.dart';

import 'package:expenso/app/modules/home/bindings/home_binding.dart';
import 'package:expenso/app/modules/home/views/home_view.dart';
import 'package:expenso/app/modules/login/bindings/login_binding.dart';
import 'package:expenso/app/modules/login/views/login_view.dart';
import 'package:expenso/app/modules/onboard/bindings/onboard_binding.dart';
import 'package:expenso/app/modules/onboard/views/onboard_view.dart';
import 'package:expenso/app/modules/signup/bindings/signup_binding.dart';
import 'package:expenso/app/modules/signup/views/signup_view.dart';
import 'package:expenso/app/modules/splash/bindings/splash_binding.dart';
import 'package:expenso/app/modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARD,
      page: () => OnboardView(),
      binding: OnboardBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
  ];
}
