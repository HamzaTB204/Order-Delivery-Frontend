import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_latest_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_top_demand_products_use_case.dart';

part 'feed_products_event.dart';
part 'feed_products_state.dart';

class FeedProductsBloc extends Bloc<FeedProductsEvent, FeedProductsState> {
  final GetLatestProductsUseCase getLatestProducts;
  final GetTopDemandProductsUseCase getTopDemandProducts;
  FeedProductsBloc(
      {required this.getLatestProducts, required this.getTopDemandProducts})
      : super(FeedProductsInitial()) {
    on<FeedProductsEvent>((event, emit) async {
      if (event is GetFeedPageProductsEvent) {
        emit(LoadingGetFeedPageProductsState());
        final List<ProductEntity> latest = [];
        final latestEither = await getLatestProducts(event.token);
        latestEither.fold(
            (failure) => emit(FailedGetFeedPageProductsState(failure: failure)),
            (products) => latest.addAll(products));
        final topDemandEither = await getTopDemandProducts(event.token);
        topDemandEither.fold(
            (failure) => emit(FailedGetFeedPageProductsState(failure: failure)),
            (products) => emit(LoadedFeedPageProductsState(
                latest: latest, topDemand: products)));
      }
    });
  }
}
