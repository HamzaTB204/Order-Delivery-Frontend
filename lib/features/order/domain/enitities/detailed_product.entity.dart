import 'package:equatable/equatable.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';

class DetailedProductEntity implements Equatable {
  final StoreEntity store;
  final ProductEntity product;

  const DetailedProductEntity({required this.store, required this.product});

  @override
  List<Object?> get props => [store, product];

  @override
  bool? get stringify => false;
}
