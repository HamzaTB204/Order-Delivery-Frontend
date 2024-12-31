import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_product.entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/add_product_to_cart_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/add_product_to_fav_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_detailed_product_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_latest_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_random_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_top_demand_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/order_product_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/search_products_use_case.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetLatestProductsUseCase getLatestProducts;
  final GetTopDemandProductsUseCase getTopDemandProducts;
  final GetRandomProductsUseCase getRandomProducts;
  final SearchProductsUseCase searchProducts;
  final GetDetailedProductUseCase getDetailedProduct;
  final OrderProductUseCase orderProduct;
  final AddProductToCartUseCase addProductToCart;
  final AddProductToFavUseCase addProductToFav;
  ProductBloc(
      {required this.getLatestProducts,
      required this.getRandomProducts,
      required this.getTopDemandProducts,
      required this.searchProducts,
      required this.addProductToCart,
      required this.addProductToFav,
      required this.getDetailedProduct,
      required this.orderProduct})
      : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is GetLatestProductsEvent) {
        emit(LoadingGetLatestProductsState());
        final either = await getLatestProducts(event.token);
        either.fold(
            (failure) => emit(FailedGetLatestProductsState(failure: failure)),
            (products) => emit(LoadedLatestProductsState(products: products)));
      } else if (event is GetTopDemandProductsEvent) {
        emit(LoadingGetTopDemandProductsState());
        final either = await getTopDemandProducts(event.token);
        either.fold(
            (failure) =>
                emit(FailedGetTopDemandProductsState(failure: failure)),
            (products) =>
                emit(LoadedTopDemandProductsState(products: products)));
      } else if (event is GetRandomProductsEvent) {
        emit(LoadingGetRandomProductsState());
        final either = await getRandomProducts(event.token, event.pageNum);
        either.fold(
            (failure) => emit(FailedGetRandomProductsState(failure: failure)),
            (products) => emit(LoadedRandomProductsState(products: products)));
      } else if (event is SearchProductsEvent) {
        emit(LoadingSearchProductsState());
        final either =
            await searchProducts(event.token, event.query, event.pageNum);
        either.fold(
            (failure) => emit(FailedSearchProductsState(failure: failure)),
            (products) => emit(LoadedSearchProductsState(products: products)));
      } else if (event is GetDetailedProductEvent) {
        emit(LoadingGetDetailedProductState());
        final either = await getDetailedProduct(event.token, event.product);
        either.fold(
            (failure) => emit(FailedGetDetailedProductState(failure: failure)),
            (detailedProduct) => emit(
                LoadedDetailedProductState(detailedProduct: detailedProduct)));
      } else if (event is OrderProductEvent) {
        emit(LoadingOrderProductState());
        final either =
            await orderProduct(event.token, event.productId, event.quantity);
        either.fold(
            (failure) => emit(FailedOrderProductState(failure: failure)),
            (detailedProduct) => emit(DoneOrderProductState()));
      } else if (event is AddProductToCartEvent) {
        emit(LoadingAddProductToCartState());
        final either = await addProductToCart(
            event.token, event.productId, event.quantity);
        either.fold(
            (failure) => emit(FailedAddProductToCartState(failure: failure)),
            (detailedProduct) => emit(DoneAddProductToCartState()));
      } else if (event is AddProductToFavEvent) {
        emit(LoadingAddProductToFavState());
        final either = await addProductToFav(event.token, event.productId);
        either.fold(
            (failure) => emit(FailedAddProductToFavState(failure: failure)),
            (detailedProduct) => emit(DoneAddProductToFavState()));
      }
    });
  }
}
