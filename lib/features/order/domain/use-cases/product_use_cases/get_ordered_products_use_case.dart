import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/order_entity.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

class GetUserOrdersUseCase extends Equatable {
  final ProductRepository productRepository;

  const GetUserOrdersUseCase({required this.productRepository});

  Future<Either<AppFailure, List<OrderEntity>>> call(String token) async {
    return await productRepository.getUserOrders(token);
  }

  @override
  List<Object?> get props => [productRepository];
}
