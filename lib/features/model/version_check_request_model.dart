class VersionCheckRequestModel {
  final String version;
  final String buildNo;
  final String deviceType;

  VersionCheckRequestModel({
    required this.version,
    required this.buildNo,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'buildNo': buildNo,
        'deviceType': deviceType,
      };
}
