import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class AddProductToFavUseCase extends Equatable {
  final ProductRepository productRepository;

  const AddProductToFavUseCase({required this.productRepository});

  Future<Either<AppFailure, Unit>> call(String token, String productId) async {
    return await productRepository.addProductToFavorite(token, productId);
  }

  @override
  List<Object?> get props => [productRepository];
}
