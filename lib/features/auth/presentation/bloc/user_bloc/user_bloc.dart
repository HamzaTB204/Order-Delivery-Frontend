import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/use-cases/user_repo/change_user_lang_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/user_repo/update_profile_use_case.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UpdateProfileUseCase updateProfile;
  final ChangeUserLangUseCase changeUserLang;
  UserBloc({required this.updateProfile, required this.changeUserLang})
      : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is UpdateUserProfileEvent) {
        emit(UpdatingUserProfileState());
        final either = await updateProfile(event.firstName, event.lastName,
            event.image, event.location, event.token);
        either.fold((failure) => emit(FailedUserState(failure: failure)),
            (_) => emit(UpdatedUserProfileState()));
      } else if (event is ChangeUserLanguageEvent) {
        emit(ChangingUserLanguageState());
        final either = await changeUserLang(event.token, event.locale);
        either.fold((failure) => emit(FailedUserState(failure: failure)),
            (_) => emit(ChangedUserLanguageState()));
      }
    });
  }
}
