import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class OrderFavProductsUseCase extends Equatable {
  final ProductRepository productRepository;

  const OrderFavProductsUseCase({required this.productRepository});

  Future<Either<AppFailure, Unit>> call(String token) async {
    return await productRepository.orderFavProducts(token);
  }

  @override
  List<Object?> get props => [productRepository];
}
