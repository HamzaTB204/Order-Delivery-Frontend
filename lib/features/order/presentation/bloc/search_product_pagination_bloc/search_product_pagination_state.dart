part of 'search_product_pagination_bloc.dart';

@immutable
sealed class SearchProductPaginationState extends Equatable{
  const SearchProductPaginationState() ;

  @override
  List<Object?> get props => [];
}

final class SearchProductPaginationInitial extends SearchProductPaginationState {}

final class LoadingSearchProductsState extends SearchProductPaginationState {}


final class FailedSearchProductsState extends SearchProductPaginationState {
  final AppFailure failure;

  const FailedSearchProductsState({required this.failure});

  @override
  List<Object> get props => [failure];
}


final class LoadedSearchProductsState extends SearchProductPaginationState {
  final List<ProductEntity> products;

  const LoadedSearchProductsState({required this.products});
  @override
  List<Object> get props => [products];
}