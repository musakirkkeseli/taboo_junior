import '../../core/utility/logger_service.dart';

class ApiListResponse<T> {
  final List<Errors>? errors;
  final List<T>? data;

  ApiListResponse({
    this.errors,
    this.data,
  });

  /// JSON'dan nesne oluşturma
  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    MyLog("ApiListResponse").d(json);

    final rawData = json['data'] ?? [];
    final rawErrors = json['errors'] ?? [];

    return ApiListResponse<T>(
      errors: rawErrors is List
          ? rawErrors
              .map((item) => Errors.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      data: rawData is List
          ? rawData
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// Nesneyi JSON'a çevirme
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'data': (data ?? []).map((item) => toJsonT(item)).toList(),
      'errors': (errors ?? []).map((item) => item.toJson()).toList(),
    };
  }
}

class Errors {
  String? message;

  Errors({this.message});

  Errors.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}
