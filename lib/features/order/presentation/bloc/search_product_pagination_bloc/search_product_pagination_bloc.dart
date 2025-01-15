import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/enitities/product_entity.dart';
import '../../../domain/use-cases/product_use_cases/search_products_use_case.dart';

part 'search_product_pagination_event.dart';
part 'search_product_pagination_state.dart';

class SearchProductPaginationBloc
    extends Bloc<SearchProductPaginationEvent, SearchProductPaginationState> {
  final SearchProductsUseCase searchProducts;
  SearchProductPaginationBloc({required this.searchProducts})
      : super(SearchProductPaginationInitial()) {
    on<SearchProductPaginationEvent>((event, emit) async {
      if (event is SearchProductsEvent) {
        emit(LoadingSearchProductsState());
        final either =
            await searchProducts(event.token, event.query, event.pageNum);
        either.fold(
            (failure) => emit(FailedSearchProductsState(failure: failure)),
            (products) => emit(LoadedSearchProductsState(products: products)));
      }
    });
  }
}
