import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class _TaggedPrinter extends LogPrinter {
  final String? tag;
  final PrettyPrinter _prettyPrinter;

  _TaggedPrinter(this.tag) : _prettyPrinter = PrettyPrinter();

  @override
  List<String> log(LogEvent event) {
    final lines = _prettyPrinter.log(event);
    if (tag != null) {
      return lines.map((line) => '[$tag] $line').toList();
    } else {
      return lines;
    }
  }
}

class MyLog {
  final Logger _logger;

  /// Instance yapısı: MyLog('Tag')
  MyLog([String? tag]) : _logger = Logger(printer: _TaggedPrinter(tag));

  // ---------- STATIC (Tag'siz Genel Kullanım) ----------
  static final Logger _globalLogger = Logger();

  static void debug(dynamic message) {
    if (!kReleaseMode) _globalLogger.d(message);
  }

  static void info(dynamic message) {
    if (!kReleaseMode) _globalLogger.i(message);
  }

  static void warning(dynamic message) {
    if (!kReleaseMode) _globalLogger.w(message);
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!kReleaseMode) _globalLogger.e(message, error: error, stackTrace: stackTrace);
  }

  // ---------- INSTANCE (Etiketli Kullanım) ----------
  void d(dynamic message) {
    if (!kReleaseMode) _logger.d(message);
  }

  void i(dynamic message) {
    if (!kReleaseMode) _logger.i(message);
  }

  void w(dynamic message) {
    if (!kReleaseMode) _logger.w(message);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!kReleaseMode) _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
