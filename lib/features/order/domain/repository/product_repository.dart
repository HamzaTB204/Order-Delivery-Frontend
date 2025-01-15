import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_product.entity.dart';
import 'package:order_delivery/features/order/domain/enitities/order_entity.dart';
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

  Future<Either<AppFailure, List<ProductEntity>>> getFavProducts(String token);
  Future<Either<AppFailure, List<ProductEntity>>> getCartProducts(String token);

  Future<Either<AppFailure, Unit>> orderProduct(
      String token, String productId, int quantity);
  Future<Either<AppFailure, Unit>> addProductToFavorite(
      String token, String productId);
  Future<Either<AppFailure, Unit>> addProductToCart(
      String token, String productId, int quantity);
  Future<Either<AppFailure, Unit>> orderFavProducts(String token);
  Future<Either<AppFailure, Unit>> orderCartProducts(String token);

  Future<Either<AppFailure, List<OrderEntity>>> getUserOrders(String token);
  Future<Either<AppFailure, Unit>> cancelOrder(String token, String orderId);
  Future<Either<AppFailure, Unit>> deleteCart(String token, String productId);
  Future<Either<AppFailure, Unit>> deleteFav(String token, String productId);
  Future<Either<AppFailure, Unit>> updateOrder(
      String token, String productId, int quantity);
  Future<Either<AppFailure, Unit>> updateCart(
      String token, String productId, int quantity);

//* neu methoden zum anwenden
  Future<Either<AppFailure, Unit>> updateDriverOrder(
      String token, String orderId, String newStatus);
  Future<Either<AppFailure, List<OrderEntity>>> getDriverOrders(String token);
}
