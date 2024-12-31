part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserProfileEvent extends UserEvent {
  final String firstName, lastName, location, token;
  final File? image;

  const UpdateUserProfileEvent(
      {required this.firstName,
      required this.lastName,
      required this.location,
      required this.token,
      required this.image});

  @override
  List<Object> get props => image == null
      ? [firstName, lastName, location, token]
      : [firstName, lastName, location, token, image!];
}

class ChangeUserLanguageEvent extends UserEvent {
  final String token, locale;

  const ChangeUserLanguageEvent({required this.token, required this.locale});
  @override
  List<Object> get props => [token, locale];
}
