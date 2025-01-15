part of 'get_product_bloc.dart';

sealed class GetProductState extends Equatable {
  const GetProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends GetProductState {}

// loading states

final class LoadingSearchProductsState extends GetProductState {}

final class LoadingGetFavProductState extends GetProductState {}

final class LoadingGetCartProductState extends GetProductState {}

final class LoadingGetUserOrdersState extends GetProductState {}

final class LoadingGetDriverOrdersState extends GetProductState {}

// failed states

final class FailedSearchProductsState extends GetProductState {
  final AppFailure failure;

  const FailedSearchProductsState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedGetFavProductState extends GetProductState {
  final AppFailure failure;

  const FailedGetFavProductState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedGetCartProductState extends GetProductState {
  final AppFailure failure;

  const FailedGetCartProductState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedGetUserOrdersState extends GetProductState {
  final AppFailure failure;

  const FailedGetUserOrdersState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedGetDriverOrdersState extends GetProductState {
  final AppFailure failure;

  const FailedGetDriverOrdersState({required this.failure});

  @override
  List<Object> get props => [failure];
}
// loaded states

final class LoadedSearchProductsState extends GetProductState {
  final List<ProductEntity> products;

  const LoadedSearchProductsState({required this.products});
  @override
  List<Object> get props => [products];
}

final class DoneGetFavProductState extends GetProductState {
  final List<ProductEntity> products;

  const DoneGetFavProductState({required this.products});
  @override
  List<Object> get props => [products];
}

final class DoneGetCartProductState extends GetProductState {
  final List<ProductEntity> products;

  const DoneGetCartProductState({required this.products});
  @override
  List<Object> get props => [products];
}

final class DoneGetUserOrdersState extends GetProductState {
  final List<OrderEntity> orders;

  const DoneGetUserOrdersState({required this.orders});
  @override
  List<Object> get props => [orders];
}

final class DoneGetDriverOrdersState extends GetProductState {
  final List<OrderEntity> orders;

  const DoneGetDriverOrdersState({required this.orders});
  @override
  List<Object> get props => [orders];
}
