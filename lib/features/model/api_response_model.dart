import '../../core/utility/logger_service.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  /// JSON'dan nesne oluşturma
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    MyLog("ApiResponse").d(json);

    final rawData = json['data'];

    T? parsedData;
    if (rawData is List) {
      // T list tipiyse, fromJsonT eleman bazında çalıştırılır
      parsedData =
          List<dynamic>.from(rawData.map((item) => fromJsonT(item))) as T;
    } else if (rawData != null) {
      parsedData = fromJsonT(rawData);
    }

    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }

  /// Nesneyi JSON'a çevirme
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    final T? rawData = data;
    dynamic encodedData;

    if (rawData is List) {
      encodedData = rawData.map((item) => toJsonT(item)).toList();
    } else if (rawData != null) {
      encodedData = toJsonT(rawData);
    }

    return {
      'success': success,
      'message': message,
      'data': encodedData,
    };
  }
}
