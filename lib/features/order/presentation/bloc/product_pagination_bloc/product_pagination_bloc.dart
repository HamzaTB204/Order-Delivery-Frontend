import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/enitities/product_entity.dart';
import '../../../domain/use-cases/product_use_cases/get_random_products_use_case.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'product_pagination_event.dart';
part 'product_pagination_state.dart';

class ProductPaginationBloc
    extends Bloc<ProductPaginationEvent, ProductPaginationState> {
  final GetRandomProductsUseCase getRandomProducts;

  ProductPaginationBloc({required this.getRandomProducts})
      : super(ProductPaginationInitial()) {
    on<ProductPaginationEvent>((event, emit) async {
      if (event is GetRandomProductsEvent) {
        emit(LoadingGetRandomProductsState());
        final either = await getRandomProducts(event.token, event.pageNum);
        either.fold(
            (failure) => emit(FailedGetRandomProductsState(failure: failure)),
            (products) => emit(LoadedRandomProductsState(products: products)));
      }
    }, transformer: droppable());
  }
}
