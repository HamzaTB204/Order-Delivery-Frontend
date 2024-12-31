part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

// loading states
final class LoadingGetLatestProductsState extends ProductState {}

final class LoadingGetTopDemandProductsState extends ProductState {}

final class LoadingGetRandomProductsState extends ProductState {}

final class LoadingSearchProductsState extends ProductState {}

final class LoadingGetDetailedProductState extends ProductState {}

final class LoadingOrderProductState extends ProductState {}

final class LoadingAddProductToFavState extends ProductState {}

final class LoadingAddProductToCartState extends ProductState {}

// failed states
final class FailedGetLatestProductsState extends ProductState {
  final AppFailure failure;

  const FailedGetLatestProductsState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedGetTopDemandProductsState extends ProductState {
  final AppFailure failure;

  const FailedGetTopDemandProductsState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedGetRandomProductsState extends ProductState {
  final AppFailure failure;

  const FailedGetRandomProductsState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedSearchProductsState extends ProductState {
  final AppFailure failure;

  const FailedSearchProductsState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedGetDetailedProductState extends ProductState {
  final AppFailure failure;

  const FailedGetDetailedProductState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedOrderProductState extends ProductState {
  final AppFailure failure;

  const FailedOrderProductState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedAddProductToFavState extends ProductState {
  final AppFailure failure;

  const FailedAddProductToFavState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedAddProductToCartState extends ProductState {
  final AppFailure failure;

  const FailedAddProductToCartState({required this.failure});

  @override
  List<Object> get props => [failure];
}

// loaded states
final class LoadedLatestProductsState extends ProductState {
  final List<ProductEntity> products;

  const LoadedLatestProductsState({required this.products});
  @override
  List<Object> get props => [products];
}

final class LoadedTopDemandProductsState extends ProductState {
  final List<ProductEntity> products;

  const LoadedTopDemandProductsState({required this.products});
  @override
  List<Object> get props => [products];
}

final class LoadedRandomProductsState extends ProductState {
  final List<ProductEntity> products;

  const LoadedRandomProductsState({required this.products});
  @override
  List<Object> get props => [products];
}

final class LoadedSearchProductsState extends ProductState {
  final List<ProductEntity> products;

  const LoadedSearchProductsState({required this.products});
  @override
  List<Object> get props => [products];
}

final class LoadedDetailedProductState extends ProductState {
  final DetailedProductEntity detailedProduct;

  const LoadedDetailedProductState({required this.detailedProduct});

  @override
  List<Object> get props => [detailedProduct];
}

final class DoneOrderProductState extends ProductState {}

final class DoneAddProductToFavState extends ProductState {}

final class DoneAddProductToCartState extends ProductState {}
