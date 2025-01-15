import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/enitities/detailed_store_enitity.dart';
import '../../../domain/use-cases/store_use_cases/get_detailed_store_use_case.dart';

part 'detailed_store_pagination_event.dart';
part 'detailed_store_pagination_state.dart';

class DetailedStorePaginationBloc
    extends Bloc<DetailedStorePaginationEvent, DetailedStorePaginationState> {
  final GetDetailedStoreUseCase getDetailedStore;

  DetailedStorePaginationBloc({required this.getDetailedStore})
      : super(DetailedStorePaginationInitial()) {
    on<DetailedStorePaginationEvent>((event, emit) async {
      if (event is GetDetailedStoreEvent) {
        emit(LoadingDetailedStoreState());
        final either =
            await getDetailedStore(event.token, event.storeId, event.pageNum);
        either.fold(
            (failure) => emit(FailedDetailedStoreState(failure: failure)),
            (detailedStore) =>
                emit(LoadedDetailedStoreState(detailedStore: detailedStore)));
      }
    });
  }
}
