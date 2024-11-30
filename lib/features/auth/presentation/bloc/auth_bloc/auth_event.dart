part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class DefineCurrentStateEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class SignupEvent extends AuthEvent {
  final String phoneNumber, password;

  SignupEvent({required this.phoneNumber, required this.password});
  @override
  List<Object?> get props => [phoneNumber, password];
}

class LoginEvent extends AuthEvent {
  final String phoneNumber, password;

  LoginEvent({required this.phoneNumber, required this.password});
  @override
  List<Object?> get props => [phoneNumber, password];
}

class LogoutEvent extends AuthEvent {
  final String token;

  LogoutEvent({required this.token});

  @override
  List<Object?> get props => [];
}
