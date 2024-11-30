import 'package:get_it/get_it.dart';
import 'package:order_delivery/features/auth/data/data-sources/auth_remote_data_source.dart';
import 'package:order_delivery/features/auth/data/data-sources/user_local_data_source.dart';
import 'package:order_delivery/features/auth/data/data-sources/user_remote_data_source.dart';
import 'package:order_delivery/features/auth/data/repository/auth_repository.dart';
import 'package:order_delivery/features/auth/data/repository/user_repository.dart';
import 'package:order_delivery/features/auth/domain/repository/auth_repository.dart';
import 'package:order_delivery/features/auth/domain/repository/user_repository.dart';
import 'package:order_delivery/features/auth/domain/use-cases/auth_repo/login_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/auth_repo/logout_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/auth_repo/signup_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/user_repo/get_local_user_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/user_repo/update_profile_use_case.dart';
import 'package:order_delivery/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:order_delivery/features/auth/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! features - auth

  //* bloc

  sl.registerFactory(() =>
      AuthBloc(getLocalUser: sl(), login: sl(), logout: sl(), signup: sl()));
  sl.registerFactory(() => UserBloc(updateProfile: sl()));

  //* use_cases

  sl.registerLazySingleton(() => GetLocalUserUseCase(userRepository: sl()));
  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignupUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(userRepository: sl()));

  //* repository

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(userLDS: sl(), authRDS: sl()));

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userLDS: sl(), userRDS: sl()));

  //* data_sources

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl());

  sl.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(sharedPreferences: sl()));

  //! core

  //!extra
  final sharedPreferences = await SharedPreferences.getInstance();
  final client = http.Client();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => client);
}
