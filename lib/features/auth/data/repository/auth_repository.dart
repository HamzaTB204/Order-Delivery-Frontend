import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/data/data-sources/auth_remote_data_source.dart';
import 'package:order_delivery/features/auth/data/data-sources/user_local_data_source.dart';
import 'package:order_delivery/features/auth/data/models/user_model.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserLocalDataSource userLDS;
  final AuthRemoteDataSource authRDS;

  AuthRepositoryImpl({required this.userLDS, required this.authRDS});
  @override
  Future<Either<AppFailure, Unit>> signup(
      String phoneNumber, String password) async {
    try {
      await authRDS.signup(phoneNumber, password);
      await userLDS.storeUser(_createSignedupUser(phoneNumber, password));
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }

  @override
  Future<Either<AppFailure, UserEntity>> login(
      String phoneNumber, String password) async {
    try {
      final UserModel user = await authRDS.login(phoneNumber, password);
      await userLDS.storeUser(user);
      return Right(user.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> logout(String token) async {
    try {
      await authRDS.logout(token);
      await userLDS.storeUser(null);
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }

  UserModel _createSignedupUser(String phoneNumber, String password) {
    return UserModel(
        phoneNumber: phoneNumber,
        password: password,
        token: '-1',
        role: null,
        firstName: null,
        lastName: null,
        profilePictureURL: null,
        location: null,
        locale: null);
  }

  @override
  List<Object?> get props => [userLDS, authRDS];

  @override
  bool? get stringify => false;
}
