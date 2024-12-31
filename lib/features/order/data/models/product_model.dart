import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel(
      {required super.productId,
      required super.storeId,
      required super.englishName,
      required super.arabicName,
      required super.englishDescription,
      required super.storeName,
      required super.arabicDescription,
      required super.productPictures,
      required super.quantity,
      required super.ordersCount,
      required super.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        productId: json['id'],
        storeId: json['store_id'],
        englishName: json['en_name'],
        arabicName: json['ar_name'],
        englishDescription: json['en_description'],
        storeName: json['store_name'],
        arabicDescription: json['ar_description'],
        productPictures:
            List<String>.from(json['images'].map((image) => image['url'])),
        quantity: json['quantity'],
        ordersCount: json['orders_count'],
        price: json['price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': productId,
      'store_id': storeId,
      'en_name': englishName,
      'ar_name': arabicName,
      'en_description': englishDescription,
      'store_name': storeName,
      'ar_description': arabicDescription,
      'images': productPictures,
      'quantity': quantity,
      'orders_count': ordersCount,
      'price': price,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
        productId: productId,
        storeId: storeId,
        englishName: englishName,
        arabicName: arabicName,
        englishDescription: englishDescription,
        storeName: storeName,
        arabicDescription: arabicDescription,
        productPictures: productPictures,
        quantity: quantity,
        ordersCount: ordersCount,
        price: price);
  }
}
