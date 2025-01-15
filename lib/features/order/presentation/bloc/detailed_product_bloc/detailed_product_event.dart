part of 'detailed_product_bloc.dart';

sealed class DetailedProductEvent extends Equatable {
  const DetailedProductEvent();

  @override
  List<Object> get props => [];
}

class GetDetailedProductEvent extends DetailedProductEvent {
  final String token;
  final ProductEntity product;

  const GetDetailedProductEvent({required this.token, required this.product});

  @override
  List<Object> get props => [token, product];
}
