import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/data/data-sources/product_remote_data_source.dart';
import 'package:order_delivery/features/order/data/models/order_model.dart';
import 'package:order_delivery/features/order/data/models/product_model.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_product.entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

typedef ProductsGetterFunc = Future<List<ProductModel>> Function();
typedef ProductsPosterFunc = Future<void> Function();
typedef OrderGetterFunc = Future<List<OrderModel>> Function();

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRDS;

  const ProductRepositoryImpl({required this.productRDS});

  @override
  Future<Either<AppFailure, List<ProductEntity>>> getLatestProducts(
      String token) async {
    return await _mapGetProducts(() => productRDS.getLatestProducts(token));
  }

  @override
  Future<Either<AppFailure, List<ProductEntity>>> getRandomProducts(
      String token, int pageNum) async {
    return await _mapGetProducts(
        () => productRDS.getRandomProducts(token, pageNum));
  }

  @override
  Future<Either<AppFailure, List<ProductEntity>>> getTopDemandProducts(
      String token) async {
    return await _mapGetProducts(() => productRDS.getTopDemandProducts(token));
  }

  @override
  Future<Either<AppFailure, List<ProductEntity>>> searchProducts(
      String token, String query, int pageNum) async {
    return await _mapGetProducts(
        () => productRDS.searchProducts(token, query, pageNum));
  }

  @override
  Future<Either<AppFailure, DetailedProductEntity>> getDetailedProduct(
      String token, ProductEntity product) async {
    try {
      final DetailedProductEntity detailedProduct =
          await productRDS.getDetailedProduct(token, product);
      return Right(detailedProduct);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> addProductToCart(
      String token, String productId, int quantity) async {
    return await _mapUnitProducts(
        () => productRDS.addProductToCart(token, productId, quantity));
  }

  @override
  Future<Either<AppFailure, Unit>> addProductToFavorite(
      String token, String productId) async {
    return await _mapUnitProducts(
        () => productRDS.addProductToFavorite(token, productId));
  }

  @override
  Future<Either<AppFailure, Unit>> orderProduct(
      String token, String productId, int quantity) async {
    return await _mapUnitProducts(
        () => productRDS.orderProduct(token, productId, quantity));
  }

  @override
  Future<Either<AppFailure, List<ProductEntity>>> getCartProducts(
      String token) async {
    return await _mapGetProducts(() => productRDS.getCartProducts(token));
  }

  @override
  Future<Either<AppFailure, List<ProductEntity>>> getFavProducts(
      String token) async {
    return await _mapGetProducts(() => productRDS.getFavProducts(token));
  }

  @override
  Future<Either<AppFailure, Unit>> orderCartProducts(String token) async {
    return await _mapUnitProducts(() => productRDS.orderCartProducts(token));
  }

  @override
  Future<Either<AppFailure, Unit>> orderFavProducts(String token) async {
    return await _mapUnitProducts(() => productRDS.orderFavProducts(token));
  }

  @override
  Future<Either<AppFailure, Unit>> cancelOrder(
      String token, String orderId) async {
    return await _mapUnitProducts(() => productRDS.cancelOrder(token, orderId));
  }

  @override
  Future<Either<AppFailure, Unit>> deleteCart(String token, String id) async {
    return await _mapUnitProducts(() => productRDS.deleteCart(token, id));
  }

  @override
  Future<Either<AppFailure, Unit>> deleteFav(String token, String id) async {
    return await _mapUnitProducts(() => productRDS.deleteFav(token, id));
  }

  @override
  Future<Either<AppFailure, List<OrderModel>>> getUserOrders(
      String token) async {
    return await _mapGetOrders(() => productRDS.getUserOrders(token));
  }

  @override
  Future<Either<AppFailure, Unit>> updateCart(
      String token, String id, int quantity) async {
    return await _mapUnitProducts(
        () => productRDS.updateCart(token, id, quantity));
  }

  @override
  Future<Either<AppFailure, Unit>> updateOrder(
      String token, String id, int quantity) async {
    return await _mapUnitProducts(
        () => productRDS.updateOrder(token, id, quantity));
  }

  // neu methoden zum uberprufen
  @override
  Future<Either<AppFailure, List<OrderModel>>> getDriverOrders(
      String token) async {
    return await _mapGetOrders(() => productRDS.getDriverOrders(token));
  }

  @override
  Future<Either<AppFailure, Unit>> updateDriverOrder(
      String token, String orderId, String newStatus) async {
    return await _mapUnitProducts(
        () => productRDS.changeOrderStatus(token, orderId, newStatus));
  }

  @override
  List<Object?> get props => [productRDS];

  @override
  bool? get stringify => false;

  Future<Either<AppFailure, List<ProductEntity>>> _mapGetProducts(
      ProductsGetterFunc func) async {
    try {
      final List<ProductEntity> products = await func();
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }

  Future<Either<AppFailure, Unit>> _mapUnitProducts(
      ProductsPosterFunc func) async {
    try {
      await func();
      return Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }

  Future<Either<AppFailure, List<OrderModel>>> _mapGetOrders(
      OrderGetterFunc func) async {
    try {
      final orders = await func();
      return Right(orders);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }
}
