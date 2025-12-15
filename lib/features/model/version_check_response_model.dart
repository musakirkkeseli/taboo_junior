class VersionCheckResponseModel {
  final bool? success;
  final String? message;
  final VersionCheckData? data;

  VersionCheckResponseModel({
    required this.success,
    this.message,
    this.data,
  });

  factory VersionCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return VersionCheckResponseModel(
      success: json['success'],
      message: json['message'],
      data:
          json['data'] != null ? VersionCheckData.fromJson(json['data']) : null,
    );
  }
}

class VersionCheckData {
  final String? storeUrl;

  VersionCheckData({required this.storeUrl});

  factory VersionCheckData.fromJson(Map<String, dynamic> json) {
    return VersionCheckData(
      storeUrl: json['store_url'],
    );
  }
}
