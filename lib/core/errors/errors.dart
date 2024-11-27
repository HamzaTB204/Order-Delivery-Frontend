class AppException implements Exception {
  final String message;

  const AppException({required this.message});
}

class AuthExceptiuon extends AppException {
  AuthExceptiuon({required super.message});
}

class OfflineException extends AppException {
  OfflineException({required super.message});
}

class NetworkException extends AppException {
  NetworkException({required super.message});
}

class ServerException extends AppException {
  ServerException({required super.message});
}
