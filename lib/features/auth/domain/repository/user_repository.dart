import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';

abstract class UserRepository extends Equatable {
  Future<Either<AppFailure, Unit>> updateProfile(String firstName,
      String lastName, File? image, String location, String token);
}
