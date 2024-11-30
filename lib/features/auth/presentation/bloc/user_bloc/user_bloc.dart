import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/use-cases/user_repo/update_profile_use_case.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UpdateProfileUseCase updateProfile;
  UserBloc({required this.updateProfile}) : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is UpdateUserProfileEvent) {
        final either = await updateProfile(event.firstName, event.lastName,
            event.image, event.location, event.token);
        either.fold((failure) => FailedUserState(failure: failure),
            (_) => UpdatedUserProfileState());
      }
    });
  }
}
