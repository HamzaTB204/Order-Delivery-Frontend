import 'package:order_delivery/features/order/data/models/product_model.dart';
import 'package:order_delivery/features/order/domain/enitities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel(
      {required super.status,
      required super.price,
      required super.id,
      required super.quantity,
      required super.product});

  factory OrderModel.fromJson(List<dynamic> json,
      {String status = "not available"}) {
    final order = json[0]['order details'];
    final product = json[0]['product details'];
    return OrderModel(
        status: status,
        id: order['order_id'].toString(),
        price: double.parse(order['price']).toInt(),
        quantity: order['quantity'],
        product: ProductModel.fromJson(product));
  }

  OrderEntity toEntity() {
    return OrderEntity(
        status: status,
        id: id,
        price: price,
        quantity: quantity,
        product: product);
  }
}
