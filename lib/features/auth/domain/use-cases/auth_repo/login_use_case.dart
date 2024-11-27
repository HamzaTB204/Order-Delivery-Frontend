import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase extends Equatable {
  final AuthRepository authRepository;

  const LoginUseCase({required this.authRepository});

  Future<Either<AppFailure, UserEntity>> call(
      String phoneNumber, String password) async {
    return await authRepository.login(phoneNumber, password);
  }

  @override
  List<Object?> get props => [authRepository];
}
