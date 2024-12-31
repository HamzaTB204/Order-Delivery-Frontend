import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/auth/domain/repository/user_repository.dart';

class ChangeUserLangUseCase extends Equatable {
  final UserRepository userRepository;

  const ChangeUserLangUseCase({required this.userRepository});

  Future<Either<AppFailure, Unit>> call(String token, String locale) async {
    return await userRepository.changeLanguage(token, locale);
  }

  @override
  List<Object?> get props => [userRepository];
}
