import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';

abstract class UserRepository extends Equatable {
  Future<Either<AppFailure, Unit>> updateProfile(String firstName,
      String lastName, File? image, String location, String token);
  Future<Either<AppFailure, UserEntity?>> getLocalUser();

  Future<Either<AppFailure, Unit>> changeLanguage(String token, String locale);
}
