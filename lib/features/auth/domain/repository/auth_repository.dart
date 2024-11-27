import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';

abstract class AuthRepository extends Equatable {
  Future<Either<AppFailure, Unit>> signup(String phoneNumber, String password);
  Future<Either<AppFailure, UserEntity>> login(
      String phoneNumber, String password);
  Future<Either<AppFailure, Unit>> logout(String token);
}
