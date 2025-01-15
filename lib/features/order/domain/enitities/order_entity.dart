import 'package:equatable/equatable.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';

class OrderEntity implements Equatable {
  final String status, id;
  final int quantity, price;
  final ProductEntity product;

  const OrderEntity(
      {required this.status,
      required this.id,
      required this.price,
      required this.quantity,
      required this.product});

  @override
  List<Object?> get props => [status, id, price, quantity, product];

  @override
  bool? get stringify => false;
}
