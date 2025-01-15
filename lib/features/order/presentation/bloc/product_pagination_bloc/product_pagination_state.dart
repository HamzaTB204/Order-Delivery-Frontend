part of 'product_pagination_bloc.dart';

@immutable

sealed class ProductPaginationState extends Equatable {
  const ProductPaginationState();

  @override
  List<Object> get props => [];
}

final class ProductPaginationInitial extends ProductPaginationState {}


final class LoadingGetRandomProductsState extends ProductPaginationState {}


final class FailedGetRandomProductsState extends ProductPaginationState {
  final AppFailure failure;

  const FailedGetRandomProductsState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class LoadedRandomProductsState extends ProductPaginationState {
  final List<ProductEntity> products;

  const LoadedRandomProductsState({required this.products});
  @override
  List<Object> get props => [products];
}

