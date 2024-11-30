import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/domain/repository/user_repository.dart';

class GetLocalUserUseCase extends Equatable {
  final UserRepository userRepository;

  const GetLocalUserUseCase({required this.userRepository});

  Future<Either<AppFailure, UserEntity?>> call() async {
    return await userRepository.getLocalUser();
  }

  @override
  List<Object?> get props => [userRepository];
}
