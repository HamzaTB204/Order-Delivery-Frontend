import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';

class StoreModel extends StoreEntity {
  StoreModel(
      {required super.storeId,
      required super.storeName,
      required super.logo,
      required super.productCount});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
        storeId: json['store_id'],
        storeName: json['store_name'],
        logo: json['logo'],
        productCount: json['product_count']);
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'store_name': storeName,
      'logo': logo,
      'product_count': productCount
    };
  }

  StoreEntity toEntity() {
    return StoreEntity(
        storeId: storeId,
        storeName: storeName,
        logo: logo,
        productCount: productCount);
  }
}
