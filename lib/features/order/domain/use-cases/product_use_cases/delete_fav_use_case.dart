import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class DeleteFavUseCase extends Equatable {
  final ProductRepository productRepository;

  const DeleteFavUseCase({required this.productRepository});

  Future<Either<AppFailure, Unit>> call(String token, String id) async {
    return await productRepository.deleteFav(token, id);
  }

  @override
  List<Object?> get props => [productRepository];
}
