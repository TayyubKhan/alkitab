import 'dart:developer' as developer;

typedef LogCallback = void Function(
    String level, String message, String? stackTrace);

class AppLogger {
  static LogCallback? _callback;

  static void init(LogCallback callback) {
    _callback = callback;
  }

  static void d(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(message, name: 'DEBUG', error: error, stackTrace: stackTrace);
    _callback?.call('DEBUG', message, stackTrace?.toString());
  }

  static void i(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(message, name: 'INFO', error: error, stackTrace: stackTrace);
    _callback?.call('INFO', message, stackTrace?.toString());
  }

  static void w(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(message, name: 'WARN', error: error, stackTrace: stackTrace);
    _callback?.call('WARN', message, stackTrace?.toString());
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
    _callback?.call('ERROR', message, stackTrace?.toString());
  }
}
