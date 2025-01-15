part of 'search_product_pagination_bloc.dart';

@immutable
sealed class SearchProductPaginationEvent extends Equatable {
  const SearchProductPaginationEvent();

  @override
  List<Object?> get props => [];
}

class SearchProductsEvent extends SearchProductPaginationEvent {
  final String token, query;
  final int pageNum;

  const SearchProductsEvent(
      {required this.token, required this.query, required this.pageNum});

  @override
  List<Object> get props => [pageNum, query, token];
}
