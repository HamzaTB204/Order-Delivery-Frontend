import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/order_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_cart_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_driver_orders_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_fav_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_ordered_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/search_products_use_case.dart';

part 'get_product_event.dart';
part 'get_product_state.dart';

class GetProductBloc extends Bloc<GetProductEvent, GetProductState> {
  final SearchProductsUseCase searchProducts;
  final GetFavProductsUseCase getFavProducts;
  final GetCartProductsUseCase getCartProducts;
  final GetUserOrdersUseCase getUserOrders;
  final GetDriverOrdersUseCase getDriverOrders;
  GetProductBloc({
    required this.searchProducts,
    required this.getCartProducts,
    required this.getFavProducts,
    required this.getUserOrders,
    required this.getDriverOrders,
  }) : super(ProductInitial()) {
    on<GetProductEvent>((event, emit) async {
      if (event is SearchProductsEvent) {
        emit(LoadingSearchProductsState());
        final either =
            await searchProducts(event.token, event.query, event.pageNum);
        either.fold(
            (failure) => emit(FailedSearchProductsState(failure: failure)),
            (products) => emit(LoadedSearchProductsState(products: products)));
      } else if (event is GetCartProductsEvent) {
        emit(LoadingGetCartProductState());
        final either = await getCartProducts(event.token);
        either.fold(
            (failure) => emit(FailedGetCartProductState(failure: failure)),
            (products) => emit(DoneGetCartProductState(products: products)));
      } else if (event is GetFavProductsEvent) {
        emit(LoadingGetFavProductState());
        final either = await getFavProducts(event.token);
        either.fold(
            (failure) => emit(FailedGetFavProductState(failure: failure)),
            (products) => emit(DoneGetFavProductState(products: products)));
      } else if (event is GetUserOrdersEvent) {
        emit(LoadingGetUserOrdersState());
        final either = await getUserOrders(event.token);
        either.fold(
            (failure) => emit(FailedGetUserOrdersState(failure: failure)),
            (orders) => emit(DoneGetUserOrdersState(orders: orders)));
      } else if (event is GetDriverOrdersEvent) {
        emit(LoadingGetDriverOrdersState());
        final either = await getDriverOrders(event.token);
        either.fold(
            (failure) => emit(FailedGetDriverOrdersState(failure: failure)),
            (orders) => emit(DoneGetDriverOrdersState(orders: orders)));
      }
    }, transformer: concurrent());
  }
}
