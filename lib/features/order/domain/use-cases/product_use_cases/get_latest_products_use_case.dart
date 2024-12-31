import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class GetLatestProductsUseCase extends Equatable {
  final ProductRepository productRepository;

  const GetLatestProductsUseCase({required this.productRepository});

  Future<Either<AppFailure, List<ProductEntity>>> call(String token) async {
    return await productRepository.getLatestProducts(token);
  }

  @override
  List<Object?> get props => [productRepository];
}