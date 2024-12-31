import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_store_enitity.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';
import 'package:order_delivery/features/order/domain/use-cases/store_use_cases/get_detailed_store_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/store_use_cases/get_random_stores_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/store_use_cases/search_stores_use_case.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final GetRandomStoresUseCase getRandomStores;
  final SearchStoresUseCase searchStores;
  final GetDetailedStoreUseCase getDetailedStore;
  StoreBloc(
      {required this.getDetailedStore,
      required this.getRandomStores,
      required this.searchStores})
      : super(StoreInitial()) {
    on<StoreEvent>((event, emit) async {
      if (event is GetRandomStoresEvent) {
        emit(LoadingStoreState());
        final either = await getRandomStores(event.token);
        either.fold((failure) => emit(FailedStoreState(failure: failure)),
            (stores) => emit(LoadedRandomStoresState(stores: stores)));
      } else if (event is SearchStoresEvent) {
        emit(LoadingStoreState());
        final either =
            await searchStores(event.token, event.query, event.pageNum);
        either.fold((failure) => emit(FailedStoreState(failure: failure)),
            (stores) => emit(LoadedSearchStoresState(stores: stores)));
      } else if (event is GetDetailedStoreEvent) {
        emit(LoadingStoreState());
        final either =
            await getDetailedStore(event.token, event.storeId, event.pageNum);
        either.fold(
            (failure) => emit(FailedStoreState(failure: failure)),
            (detailedStore) =>
                emit(LoadedDetailedStoreState(detailedStore: detailedStore)));
      }
    });
  }
}
