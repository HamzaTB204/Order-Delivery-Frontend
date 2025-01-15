part of 'update_product_bloc.dart';

sealed class UpdateProductState extends Equatable {
  const UpdateProductState();

  @override
  List<Object> get props => [];
}

final class UpdateProductInitial extends UpdateProductState {}

// loading

final class LoadingOrderProductState extends UpdateProductState {}

final class LoadingAddProductToFavState extends UpdateProductState {}

final class LoadingAddProductToCartState extends UpdateProductState {}

final class LoadingOrderFavProductState extends UpdateProductState {}

final class LoadingOrderCartProductState extends UpdateProductState {}

final class LoadingCancelOrderState extends UpdateProductState {}

final class LoadingDeleteCartState extends UpdateProductState {}

final class LoadingDeleteFavState extends UpdateProductState {}

final class LoadingUpdateCartState extends UpdateProductState {}

final class LoadingUpdateOrderState extends UpdateProductState {}

// failed

final class FailedOrderProductState extends UpdateProductState {
  final AppFailure failure;

  const FailedOrderProductState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedAddProductToFavState extends UpdateProductState {
  final AppFailure failure;

  const FailedAddProductToFavState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedAddProductToCartState extends UpdateProductState {
  final AppFailure failure;

  const FailedAddProductToCartState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedOrderFavProductState extends UpdateProductState {
  final AppFailure failure;

  const FailedOrderFavProductState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedOrderCartProductState extends UpdateProductState {
  final AppFailure failure;

  const FailedOrderCartProductState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedCancelOrderState extends UpdateProductState {
  final AppFailure failure;

  const FailedCancelOrderState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedDeleteCartState extends UpdateProductState {
  final AppFailure failure;

  const FailedDeleteCartState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedDeleteFavState extends UpdateProductState {
  final AppFailure failure;

  const FailedDeleteFavState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedUpdateCartState extends UpdateProductState {
  final AppFailure failure;

  const FailedUpdateCartState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class FailedUpdateDriverOrderState extends UpdateProductState {
  final AppFailure failure;

  const FailedUpdateDriverOrderState({required this.failure});

  @override
  List<Object> get props => [failure];
}

// done

final class DoneOrderProductState extends UpdateProductState {
  final String productId;

  const DoneOrderProductState({required this.productId});
  @override
  List<Object> get props => [productId];
}

final class DoneAddProductToCartState extends UpdateProductState {
  final String productId;

  const DoneAddProductToCartState({required this.productId});
  @override
  List<Object> get props => [productId];
}

final class DoneAddProductToFavState extends UpdateProductState {
  final String productId;

  const DoneAddProductToFavState({required this.productId});
  @override
  List<Object> get props => [productId];
}

final class DoneOrderFavProductState extends UpdateProductState {}

final class DoneOrderCartProductState extends UpdateProductState {}

final class DoneCancelOrderState extends UpdateProductState {}

final class DoneDeleteCartState extends UpdateProductState {}

final class DoneDeleteFavState extends UpdateProductState {}

final class DoneUpdateCartState extends UpdateProductState {}

final class DoneUpdateDriverOrderState extends UpdateProductState {}
