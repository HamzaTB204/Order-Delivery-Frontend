import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/domain/use-cases/auth_repo/login_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/auth_repo/logout_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/auth_repo/signup_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/user_repo/get_local_user_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetLocalUserUseCase getLocalUser;
  final LoginUseCase login;
  final LogoutUseCase logout;
  final SignupUseCase signup;
  AuthBloc(
      {required this.getLocalUser,
      required this.login,
      required this.logout,
      required this.signup})
      : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is DefineCurrentStateEvent) {
        emit(AuthInitial());
        final either = await getLocalUser();
        either.fold((failure) => emit(FailedAuthState(failure: failure)),
            (loadedUser) => _mapLoadedUser(loadedUser, emit));
      } else if (event is SignupEvent) {
        emit(LoadingAuthState());
        final either = await signup(event.phoneNumber, event.password);
        either.fold((failure) => emit(FailedAuthState(failure: failure)),
            (_) => emit(SignedupAuthState()));
      } else if (event is LoginEvent) {
        emit(LoadingAuthState());
        final either = await login(event.phoneNumber, event.password);
        either.fold((failure) => emit(FailedAuthState(failure: failure)),
            (user) => emit(LoggedinAuthState(user: user)));
      } else if (event is LogoutEvent) {
        emit(LoadingAuthState());
        final either = await logout(event.token);
        either.fold((failure) => emit(FailedAuthState(failure: failure)),
            (user) => emit(NotLoggedinAuthState()));
      }
    });
  }

  void _mapLoadedUser(UserEntity? loadedUser, Emitter<AuthState> emit) {
    if (loadedUser == null) {
      emit(NotLoggedinAuthState());
    } else if (loadedUser.token == '-1') {
      emit(SignedupAuthState());
    } else {
      emit(LoggedinAuthState(user: loadedUser));
    }
  }
}
