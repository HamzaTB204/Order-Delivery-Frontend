import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/repository/auth_repository.dart';

class SignupUseCase extends Equatable {
  final AuthRepository authRepository;

  const SignupUseCase({required this.authRepository});

  Future<Either<AppFailure, Unit>> call(
      String phoneNumber, String password) async {
    return await authRepository.signup(phoneNumber, password);
  }

  @override
  List<Object?> get props => [authRepository];
}
