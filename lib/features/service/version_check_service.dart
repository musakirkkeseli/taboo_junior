import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../model/version_check_request_model.dart';
import '../model/version_check_response_model.dart';

class VersionCheckService {
  static const String _baseUrl = 'https://api.tabumium.com';
  static const String _checkUpdateEndpoint = '/check-update';

  /// Checks if app version is up to date
  /// Returns VersionCheckResponseModel or throws exception on error
  Future<VersionCheckResponseModel> checkVersion() async {
    try {
      // Get package info
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;

      // Detect platform
      String deviceType;
      if (Platform.isIOS) {
        deviceType = 'ios';
      } else if (Platform.isAndroid) {
        deviceType = 'android';
      } else {
        deviceType = 'unknown';
      }

      // Create request body
      final request = VersionCheckRequestModel(
        version: version,
        buildNo: buildNumber,
        deviceType: deviceType,
      );
      debugPrint('Version check request: ${request.toJson()}');

      // Make POST request
      final url = Uri.parse('$_baseUrl$_checkUpdateEndpoint');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );
      debugPrint('Version check response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return VersionCheckResponseModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to check version: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Version check error: $e');
    }
  }
}
