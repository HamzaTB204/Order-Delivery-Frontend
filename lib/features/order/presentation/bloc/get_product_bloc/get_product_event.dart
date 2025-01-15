part of 'get_product_bloc.dart';

sealed class GetProductEvent extends Equatable {
  const GetProductEvent();

  @override
  List<Object> get props => [];
}

class SearchProductsEvent extends GetProductEvent {
  final String token, query;
  final int pageNum;

  const SearchProductsEvent(
      {required this.token, required this.query, required this.pageNum});

  @override
  List<Object> get props => [pageNum, query, token];
}

class GetFavProductsEvent extends GetProductEvent {
  final String token;

  const GetFavProductsEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class GetCartProductsEvent extends GetProductEvent {
  final String token;

  const GetCartProductsEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class GetUserOrdersEvent extends GetProductEvent {
  final String token;

  const GetUserOrdersEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class GetDriverOrdersEvent extends GetProductEvent {
  final String token;

  const GetDriverOrdersEvent({required this.token});

  @override
  List<Object> get props => [token];
}
