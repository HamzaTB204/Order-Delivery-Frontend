import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/repository/user_repository.dart';

class UpdateProfileUseCase extends Equatable {
  final UserRepository userRepository;

  const UpdateProfileUseCase({required this.userRepository});

  Future<Either<AppFailure, Unit>> call(String firstName, String lastName,
      File? image, String location, String token) async {
    return await userRepository.updateProfile(
        firstName, lastName, image, location, token);
  }

  @override
  List<Object?> get props => [userRepository];
}
