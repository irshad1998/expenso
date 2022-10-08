class LoginMobileGenerateOtpSuccessResponse {
  LoginMobileGenerateOtpSuccessResponse({
    this.status,
    this.message,
    this.data,
  });

  LoginMobileGenerateOtpSuccessResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? OtpData.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  OtpData? data;

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

class OtpData {
  OtpData({
    this.otp,
  });

  OtpData.fromJson(dynamic json) {
    otp = json['otp'];
  }
  String? otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp'] = otp;
    return map;
  }
}
