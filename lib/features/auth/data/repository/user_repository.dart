import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/data/data-sources/user_local_data_source.dart';
import 'package:order_delivery/features/auth/data/data-sources/user_remote_data_source.dart';
import 'package:order_delivery/features/auth/data/models/user_model.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource userLDS;
  final UserRemoteDataSource userRDS;

  const UserRepositoryImpl({required this.userLDS, required this.userRDS});

  @override
  Future<Either<AppFailure, Unit>> updateProfile(String firstName,
      String lastName, File? image, String location, String token) async {
    try {
      final profilePictureURL = await userRDS.updateProfile(
          firstName, lastName, image, location, token);
      final UserModel? user = await userLDS.loadUser();
      await userLDS.storeUser(_createUpdatedUser(user!, firstName, lastName,
          image, location, token, profilePictureURL));
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }

  @override
  Future<Either<AppFailure, UserEntity?>> getLocalUser() async {
    try {
      final UserModel? user = await userLDS.loadUser();
      return Right(user?.toEntity());
    } catch (e) {
      return Left(
          OfflineFailure(failureMessage: "Error while loading local user"));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> changeLanguage(
      String token, String locale) async {
    try {
      final userLocale = await userRDS.changeLanguage(token, locale);
      final UserModel? user = await userLDS.loadUser();
      await userLDS.storeUser(_createChangedLangUser(user!, userLocale));
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }

  UserModel _createUpdatedUser(
      UserModel user,
      String firstName,
      String lastName,
      File? image,
      String location,
      String token,
      String profilePictureURL) {
    return UserModel(
        firstName: firstName,
        lastName: lastName,
        locale: user.locale,
        location: location,
        role: user.role,
        password: user.password,
        phoneNumber: user.phoneNumber,
        token: token,
        profilePictureURL: profilePictureURL);
  }

  UserModel _createChangedLangUser(UserModel user, String locale) {
    return UserModel(
        firstName: user.firstName,
        lastName: user.lastName,
        locale: locale,
        location: user.location,
        password: user.password,
        role: user.role,
        phoneNumber: user.phoneNumber,
        token: user.token,
        profilePictureURL: user.profilePictureURL);
  }

  @override
  List<Object?> get props => [userLDS, userRDS];

  @override
  bool? get stringify => false;
}
