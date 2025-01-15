import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/enitities/store_entity.dart';
import '../../../domain/use-cases/store_use_cases/search_stores_use_case.dart';

part 'store_pagination_event.dart';
part 'store_pagination_state.dart';

class StorePaginationBloc
    extends Bloc<StorePaginationEvent, StorePaginationState> {
  final SearchStoresUseCase searchStores;

  StorePaginationBloc({required this.searchStores})
      : super(StorePaginationInitial()) {
    on<StorePaginationEvent>((event, emit) async {
      if (event is SearchStoresEvent) {
        emit(LoadingStoreState());
        final either =
            await searchStores(event.token, event.query, event.pageNum);
        either.fold((failure) => emit(FailedStoreState(failure: failure)),
            (stores) => emit(LoadedSearchStoresState(stores: stores)));
      }
    });
  }
}
