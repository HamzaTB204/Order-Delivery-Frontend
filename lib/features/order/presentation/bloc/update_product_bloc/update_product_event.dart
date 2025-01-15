part of 'update_product_bloc.dart';

sealed class UpdateProductEvent extends Equatable {
  const UpdateProductEvent();

  @override
  List<Object> get props => [];
}

class OrderProductEvent extends UpdateProductEvent {
  final String token, productId;
  final int quantity;

  const OrderProductEvent(
      {required this.token, required this.productId, required this.quantity});

  @override
  List<Object> get props => [token, productId, quantity];
}

class AddProductToCartEvent extends UpdateProductEvent {
  final String token, productId;
  final int quantity;

  const AddProductToCartEvent(
      {required this.token, required this.productId, required this.quantity});

  @override
  List<Object> get props => [token, productId, quantity];
}

class AddProductToFavEvent extends UpdateProductEvent {
  final String token, productId;

  const AddProductToFavEvent({required this.token, required this.productId});

  @override
  List<Object> get props => [token, productId];
}

class OrderCartProductsEvent extends UpdateProductEvent {
  final String token;

  const OrderCartProductsEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class OrderFavProductsEvent extends UpdateProductEvent {
  final String token;

  const OrderFavProductsEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class CancelOrderEvent extends UpdateProductEvent {
  final String token, orderId;

  const CancelOrderEvent({required this.token, required this.orderId});

  @override
  List<Object> get props => [token, orderId];
}

class DeleteCartEvent extends UpdateProductEvent {
  final String token, productId;

  const DeleteCartEvent({required this.token, required this.productId});

  @override
  List<Object> get props => [token, productId];
}

class DeleteFavEvent extends UpdateProductEvent {
  final String token, productId;

  const DeleteFavEvent({required this.token, required this.productId});

  @override
  List<Object> get props => [token, productId];
}

class UpdateCartEvent extends UpdateProductEvent {
  final String token, productId;
  final int quantity;

  const UpdateCartEvent(
      {required this.token, required this.productId, required this.quantity});

  @override
  List<Object> get props => [token, productId, quantity];
}

class UpdateOrderStatusEvent extends UpdateProductEvent {
  final String token, orderId, newState;

  const UpdateOrderStatusEvent(
      {required this.token, required this.orderId, required this.newState});

  @override
  List<Object> get props => [token, orderId, newState];
}
