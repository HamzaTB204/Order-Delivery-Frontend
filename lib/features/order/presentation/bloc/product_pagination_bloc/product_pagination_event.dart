part of 'product_pagination_bloc.dart';

@immutable
sealed class ProductPaginationEvent extends Equatable {
  const ProductPaginationEvent();

  @override
  List<Object> get props => [];
}

class GetRandomProductsEvent extends ProductPaginationEvent {
  final int pageNum;
  final String token;
  const GetRandomProductsEvent({required this.pageNum, required this.token});
  @override
  List<Object> get props => [pageNum, token];
}
