import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class CancelOrderUseCase extends Equatable {
  final ProductRepository productRepository;

  const CancelOrderUseCase({required this.productRepository});

  Future<Either<AppFailure, Unit>> call(String token, String orderId) async {
    return await productRepository.cancelOrder(token, orderId);
  }

  @override
  List<Object?> get props => [productRepository];
}
