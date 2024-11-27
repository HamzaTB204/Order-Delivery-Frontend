import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase extends Equatable {
  final AuthRepository authRepository;

  const LogoutUseCase({required this.authRepository});

  Future<Either<AppFailure, Unit>> call(String token) async {
    return await authRepository.logout(token);
  }

  @override
  List<Object?> get props => [authRepository];
}
