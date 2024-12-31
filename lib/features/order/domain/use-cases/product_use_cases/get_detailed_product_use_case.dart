import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_product.entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class GetDetailedProductUseCase extends Equatable {
  final ProductRepository productRepository;

  const GetDetailedProductUseCase({required this.productRepository});

  Future<Either<AppFailure, DetailedProductEntity>> call(
      String token, ProductEntity product) async {
    return await productRepository.getDetailedProduct(token, product);
  }

  @override
  List<Object?> get props => [productRepository];
}
