class Endpoints {
  Endpoints._();

  static const String BASE_URL = 'http://192.168.1.2:4000';

  static const String v = '/v1/';
  static const String generateSignupOtp = '${v}temporory-signup';
  static const String verifySignupOtp = '${v}verify-signup-otp';
}
