import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/add_product_to_cart_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/add_product_to_fav_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/cancel_order_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/delete_cart_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/delete_fav_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/order_cart_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/order_fav_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/order_product_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/update_cart_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/update_driver_order_use_case.dart';

part 'update_product_event.dart';
part 'update_product_state.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final OrderProductUseCase orderProduct;
  final AddProductToCartUseCase addProductToCart;
  final AddProductToFavUseCase addProductToFav;
  final OrderCartProductsUseCase orderCartProducts;
  final OrderFavProductsUseCase orderFavProducts;
  final CancelOrderUseCase cancelOrder;
  final DeleteFavUseCase deleteFav;
  final DeleteCartUseCase deleteCart;
  final UpdateDriverOrderUseCase updateDriverOrder;
  final UpdateCartUseCase updateCart;
  UpdateProductBloc({
    required this.orderProduct,
    required this.addProductToCart,
    required this.orderCartProducts,
    required this.orderFavProducts,
    required this.addProductToFav,
    required this.cancelOrder,
    required this.deleteCart,
    required this.deleteFav,
    required this.updateCart,
    required this.updateDriverOrder,
  }) : super(UpdateProductInitial()) {
    on<UpdateProductEvent>((event, emit) async {
      if (event is OrderProductEvent) {
        emit(LoadingOrderProductState());
        final either =
            await orderProduct(event.token, event.productId, event.quantity);
        either.fold(
            (failure) => emit(FailedOrderProductState(failure: failure)),
            (detailedProduct) =>
                emit(DoneOrderProductState(productId: event.productId)));
      } else if (event is AddProductToCartEvent) {
        emit(LoadingAddProductToCartState());
        final either = await addProductToCart(
            event.token, event.productId, event.quantity);
        either.fold(
            (failure) => emit(FailedAddProductToCartState(failure: failure)),
            (detailedProduct) =>
                emit(DoneAddProductToCartState(productId: event.productId)));
      } else if (event is AddProductToFavEvent) {
        emit(LoadingAddProductToFavState());
        final either = await addProductToFav(event.token, event.productId);
        either.fold(
            (failure) => emit(FailedAddProductToFavState(failure: failure)),
            (detailedProduct) =>
                emit(DoneAddProductToFavState(productId: event.productId)));
      } else if (event is OrderCartProductsEvent) {
        emit(LoadingOrderCartProductState());
        final either = await orderCartProducts(event.token);
        either.fold(
            (failure) => emit(FailedOrderCartProductState(failure: failure)),
            (products) => emit(DoneOrderCartProductState()));
      } else if (event is OrderFavProductsEvent) {
        emit(LoadingOrderFavProductState());
        final either = await orderFavProducts(event.token);
        either.fold(
            (failure) => emit(FailedOrderFavProductState(failure: failure)),
            (products) => emit(DoneOrderFavProductState()));
      }
      // !
      else if (event is CancelOrderEvent) {
        emit(LoadingCancelOrderState());
        final either = await cancelOrder(event.token, event.orderId);
        either.fold((failure) => emit(FailedCancelOrderState(failure: failure)),
            (_) => emit(DoneCancelOrderState()));
      } else if (event is DeleteCartEvent) {
        emit(LoadingDeleteCartState());
        final either = await deleteCart(event.token, event.productId);
        either.fold((failure) => emit(FailedDeleteCartState(failure: failure)),
            (_) => emit(DoneDeleteCartState()));
      } else if (event is DeleteFavEvent) {
        emit(LoadingDeleteFavState());
        final either = await deleteFav(event.token, event.productId);
        either.fold((failure) => emit(FailedDeleteFavState(failure: failure)),
            (_) => emit(DoneDeleteFavState()));
      } else if (event is UpdateOrderStatusEvent) {
        emit(LoadingUpdateOrderState());
        final either =
            await updateDriverOrder(event.token, event.orderId, event.newState);
        either.fold(
            (failure) => emit(FailedUpdateDriverOrderState(failure: failure)),
            (_) => emit(DoneUpdateDriverOrderState()));
      } else if (event is UpdateCartEvent) {
        emit(LoadingUpdateCartState());
        final either =
            await updateCart(event.token, event.productId, event.quantity);
        either.fold((failure) => emit(FailedUpdateCartState(failure: failure)),
            (_) => emit(DoneUpdateCartState()));
      }
    });
  }
}
