class GenerateOtpSuccessResponse {
  GenerateOtpSuccessResponse({
    this.status,
    this.message,
    this.data,
  });

  GenerateOtpSuccessResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? GeneratedOtpData.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  GeneratedOtpData? data;

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

class GeneratedOtpData {
  GeneratedOtpData({
    this.otp,
  });

  GeneratedOtpData.fromJson(dynamic json) {
    otp = json['otp'];
  }
  String? otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp'] = otp;
    return map;
  }
}
