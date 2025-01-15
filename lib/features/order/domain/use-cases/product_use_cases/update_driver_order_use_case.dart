import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class UpdateDriverOrderUseCase extends Equatable {
  final ProductRepository productRepository;

  const UpdateDriverOrderUseCase({required this.productRepository});

  Future<Either<AppFailure, Unit>> call(
      String token, String orderId, String newStatus) async {
    return await productRepository.updateDriverOrder(token, orderId, newStatus);
  }

  @override
  List<Object?> get props => [productRepository];
}
