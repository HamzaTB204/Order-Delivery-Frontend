class AppFailure {
  final String failureMessage;

  const AppFailure({required this.failureMessage});
}

class AuthFailure extends AppFailure {
  AuthFailure({required super.failureMessage});
}

class OfflineFailure extends AppFailure {
  OfflineFailure({required super.failureMessage});
}

class NetworkFailure extends AppFailure {
  NetworkFailure({required super.failureMessage});
}

class ServerFailure extends AppFailure {
  ServerFailure({required super.failureMessage});
}
