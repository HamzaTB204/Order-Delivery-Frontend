import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_product.entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_detailed_product_use_case.dart';

part 'detailed_product_event.dart';
part 'detailed_product_state.dart';

class DetailedProductBloc
    extends Bloc<DetailedProductEvent, DetailedProductState> {
  final GetDetailedProductUseCase getDetailedProduct;

  DetailedProductBloc({required this.getDetailedProduct})
      : super(DetailedProductInitial()) {
    on<DetailedProductEvent>((event, emit) async {
      if (event is GetDetailedProductEvent) {
        emit(LoadingGetDetailedProductState());
        final either = await getDetailedProduct(event.token, event.product);
        either.fold(
            (failure) => emit(FailedGetDetailedProductState(failure: failure)),
            (detailedProduct) => emit(
                LoadedDetailedProductState(detailedProduct: detailedProduct)));
      }
    });
  }
}
