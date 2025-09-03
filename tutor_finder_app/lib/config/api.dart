import 'dart:io' show Platform;

String apiBaseUrl() {
  final String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  return 'http://$host:8000/api';
}
