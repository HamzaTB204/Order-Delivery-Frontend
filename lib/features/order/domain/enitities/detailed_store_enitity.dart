import 'package:equatable/equatable.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';

class DetailedStoreEntity implements Equatable {
  final StoreEntity store;
  final List<ProductEntity> products;

  const DetailedStoreEntity({required this.store, required this.products});

  @override
  List<Object?> get props => [store, products];

  @override
  bool? get stringify => false;
}
