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

  factory ProductModel.fromJson(Map<String, dynamic> json,
      {String storeName = "not available", int? quantity}) {
    return ProductModel(
        productId: json['id'].toString(),
        storeId: json['store_id'].toString(),
        englishName: json['en_name'],
        arabicName: json['ar_name'],
        englishDescription: json['en_description'],
        storeName: json['store_name'] ?? storeName,
        arabicDescription: json['ar_description'],
        productPictures:
            List<String>.from(json['images'].map((image) => image['url'])),
        quantity: quantity ?? json['quantity'],
        ordersCount: json['orders_count'],
        price: double.parse(json['price']).toInt());
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
