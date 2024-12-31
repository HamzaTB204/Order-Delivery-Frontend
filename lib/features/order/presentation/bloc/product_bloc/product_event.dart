part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetLatestProductsEvent extends ProductEvent {
  final String token;

  const GetLatestProductsEvent({required this.token});
  @override
  List<Object> get props => [token];
}

class GetTopDemandProductsEvent extends ProductEvent {
  final String token;

  const GetTopDemandProductsEvent({required this.token});
  @override
  List<Object> get props => [token];
}

class GetRandomProductsEvent extends ProductEvent {
  final int pageNum;
  final String token;
  const GetRandomProductsEvent({required this.pageNum, required this.token});
  @override
  List<Object> get props => [pageNum, token];
}

class SearchProductsEvent extends ProductEvent {
  final String token, query;
  final int pageNum;

  const SearchProductsEvent(
      {required this.token, required this.query, required this.pageNum});

  @override
  List<Object> get props => [pageNum, query, token];
}

class GetDetailedProductEvent extends ProductEvent {
  final String token;
  final ProductEntity product;

  const GetDetailedProductEvent({required this.token, required this.product});

  @override
  List<Object> get props => [token, product];
}

class OrderProductEvent extends ProductEvent {
  final String token, productId;
  final int quantity;

  const OrderProductEvent(
      {required this.token, required this.productId, required this.quantity});

  @override
  List<Object> get props => [token, productId, quantity];
}

class AddProductToCartEvent extends ProductEvent {
  final String token, productId;
  final int quantity;

  const AddProductToCartEvent(
      {required this.token, required this.productId, required this.quantity});

  @override
  List<Object> get props => [token, productId, quantity];
}

class AddProductToFavEvent extends ProductEvent {
  final String token, productId;

  const AddProductToFavEvent({required this.token, required this.productId});

  @override
  List<Object> get props => [token, productId];
}
