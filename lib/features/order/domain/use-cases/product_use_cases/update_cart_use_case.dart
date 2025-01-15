import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class UpdateCartUseCase extends Equatable {
  final ProductRepository productRepository;

  const UpdateCartUseCase({required this.productRepository});

  Future<Either<AppFailure, Unit>> call(
      String token, String id, int quantity) async {
    return await productRepository.updateCart(token, id, quantity);
  }

  @override
  List<Object?> get props => [productRepository];
}
