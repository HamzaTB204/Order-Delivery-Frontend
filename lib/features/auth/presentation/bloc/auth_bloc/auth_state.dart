part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoadingAuthState extends AuthState {}

class SignedupAuthState extends AuthState {}

class LoggedinAuthState extends AuthState {
  final UserEntity user;

  const LoggedinAuthState({required this.user});
  @override
  List<Object> get props => [user];
}

class NotLoggedinAuthState extends AuthState {}

class FailedAuthState extends AuthState {
  final AppFailure failure;

  const FailedAuthState({required this.failure});
  @override
  List<Object> get props => [failure];
}
