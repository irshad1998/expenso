part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARD = _Paths.ONBOARD;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
}

abstract class _Paths {
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const ONBOARD = '/onboard';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
}
