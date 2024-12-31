import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class OrderProductUseCase extends Equatable {
  final ProductRepository productRepository;

  const OrderProductUseCase({required this.productRepository});

  Future<Either<AppFailure, Unit>> call(
      String token, String productId, int quantity) async {
    return await productRepository.orderProduct(token, productId, quantity);
  }

  @override
  List<Object?> get props => [productRepository];
}
