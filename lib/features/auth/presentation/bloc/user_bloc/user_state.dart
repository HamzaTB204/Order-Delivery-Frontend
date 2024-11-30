part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UpdatingUserProfileState extends UserState {}

class UpdatedUserProfileState extends UserState {}

class FailedUserState extends UserState {
  final AppFailure failure;

  const FailedUserState({required this.failure});
  @override
  List<Object> get props => [failure];
}
