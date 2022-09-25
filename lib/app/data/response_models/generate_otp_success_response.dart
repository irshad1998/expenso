class GenerateOtpSuccessResponse {
  GenerateOtpSuccessResponse({
    this.status,
    this.message,
    this.data,
  });

  GenerateOtpSuccessResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OtpData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<OtpData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
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
