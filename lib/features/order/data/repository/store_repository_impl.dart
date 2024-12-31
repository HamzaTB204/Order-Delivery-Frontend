import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/data/data-sources/store_remote_data_source.dart';
import 'package:order_delivery/features/order/data/models/store_module.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_store_enitity.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';
import 'package:order_delivery/features/order/domain/repository/store_repository.dart';

typedef StoresGetterFunc = Future<List<StoreModel>> Function();

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource storeRDS;

  const StoreRepositoryImpl({required this.storeRDS});

  @override
  Future<Either<AppFailure, DetailedStoreEntity>> getDetailedStore(
      String token, String storeId, int pageNum) async {
    try {
      final DetailedStoreEntity dse =
          await storeRDS.getDetailedStore(token, storeId, pageNum);
      return Right(dse);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }

  @override
  Future<Either<AppFailure, List<StoreEntity>>> getRandomStores(
      String token) async {
    return await _mapGetStores(() => storeRDS.getRandomStores(token));
  }

  @override
  Future<Either<AppFailure, List<StoreEntity>>> searchStores(
      String token, String query, int pageNum) async {
    return await _mapGetStores(
        () => storeRDS.searchStores(token, query, pageNum));
  }

  @override
  List<Object?> get props => [storeRDS];

  @override
  bool? get stringify => false;

  Future<Either<AppFailure, List<StoreEntity>>> _mapGetStores(
      StoresGetterFunc func) async {
    try {
      final List<StoreEntity> stores = await func();
      return Right(stores);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(failureMessage: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMessage: e.message));
    }
  }
}
