import 'package:equatable/equatable.dart';

class StoreEntity implements Equatable {
  final String storeId, storeName, logo;
  final int productCount;

  StoreEntity(
      {required this.storeId,
      required this.storeName,
      required this.logo,
      required this.productCount});

  @override
  List<Object?> get props => [storeId, storeName, logo, productCount];

  @override
  bool? get stringify => false;
}
