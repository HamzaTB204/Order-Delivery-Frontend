import 'package:equatable/equatable.dart';

class ProductEntity implements Equatable {
  final String productId,
      storeId,
      englishName,
      arabicName,
      englishDescription,
      storeName,
      arabicDescription;
  final List<String> productPictures;
  final int quantity, ordersCount, price;

  ProductEntity({
    required this.productId,
    required this.storeId,
    required this.englishName,
    required this.arabicName,
    required this.englishDescription,
    required this.storeName,
    required this.arabicDescription,
    required this.productPictures,
    required this.quantity,
    required this.ordersCount,
    required this.price,
  });

  @override
  List<Object?> get props => [
        productId,
        storeId,
        englishName,
        arabicName,
        englishDescription,
        storeName,
        arabicDescription,
        productPictures,
        quantity,
        ordersCount,
        price,
      ];

  @override
  bool? get stringify => false;
}
