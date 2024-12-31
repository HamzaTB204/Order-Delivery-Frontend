import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/data/data-sources/product_remote_data_source.dart';
import 'package:order_delivery/features/order/data/models/product_model.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_product.entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';

typedef ProductsGetterFunc = Future<List<ProductModel>> Function();
typedef ProductsPosterFunc = Future<void> Function();

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
    return await _mapPostProducts(
        () => productRDS.addProductToCart(token, productId, quantity));
  }

  @override
  Future<Either<AppFailure, Unit>> addProductToFavorite(
      String token, String productId) async {
    return await _mapPostProducts(
        () => productRDS.addProductToFavorite(token, productId));
  }

  @override
  Future<Either<AppFailure, Unit>> orderProduct(
      String token, String productId, int quantity) async {
    return await _mapPostProducts(
        () => productRDS.orderProduct(token, productId, quantity));
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

  Future<Either<AppFailure, Unit>> _mapPostProducts(
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
}
