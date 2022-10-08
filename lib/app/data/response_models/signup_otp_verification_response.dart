class OtpVerificationResponse {
  OtpVerificationResponse({
    this.status,
    this.message,
    this.data,
  });

  OtpVerificationResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? SignupOtpVerificationData.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  SignupOtpVerificationData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class SignupOtpVerificationData {
  SignupOtpVerificationData({
    this.token,
  });

  SignupOtpVerificationData.fromJson(dynamic json) {
    token = json['token'];
  }
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    return map;
  }
}
