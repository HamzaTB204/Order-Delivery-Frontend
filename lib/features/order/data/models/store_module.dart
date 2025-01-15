import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';

class StoreModel extends StoreEntity {
  StoreModel(
      {required super.storeId,
      required super.storeName,
      required super.logo,
      required super.productCount});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
        storeId: json['id'].toString(),
        storeName: json['name'],
        logo: json['logo'],
        productCount: json['product_count']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': storeId,
      'name': storeName,
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
