import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_product.entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';

abstract class ProductRepository implements Equatable {
  Future<Either<AppFailure, List<ProductEntity>>> getTopDemandProducts(
      String token);
  Future<Either<AppFailure, List<ProductEntity>>> getLatestProducts(
      String token);
  Future<Either<AppFailure, List<ProductEntity>>> getRandomProducts(
      String token, int pageNum);
  Future<Either<AppFailure, List<ProductEntity>>> searchProducts(
      String token, String query, int pageNum);

  Future<Either<AppFailure, DetailedProductEntity>> getDetailedProduct(
      String token, ProductEntity product);

  Future<Either<AppFailure, Unit>> orderProduct(
      String token, String productId, int quantity);
  Future<Either<AppFailure, Unit>> addProductToFavorite(
      String token, String productId);
  Future<Either<AppFailure, Unit>> addProductToCart(
      String token, String productId, int quantity);
}
