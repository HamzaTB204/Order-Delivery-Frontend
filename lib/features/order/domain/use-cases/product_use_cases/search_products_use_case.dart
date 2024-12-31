import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class SearchProductsUseCase extends Equatable {
  final ProductRepository productRepository;

  const SearchProductsUseCase({required this.productRepository});

  Future<Either<AppFailure, List<ProductEntity>>> call(
      String token, String query, int pageNum) async {
    return await productRepository.searchProducts(token, query, pageNum);
  }

  @override
  List<Object?> get props => [productRepository];
}
