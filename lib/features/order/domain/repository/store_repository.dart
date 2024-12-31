import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_store_enitity.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';

abstract class StoreRepository implements Equatable {
  Future<Either<AppFailure, List<StoreEntity>>> getRandomStores(String token);
  Future<Either<AppFailure, List<StoreEntity>>> searchStores(
      String token, String query, int pageNum);
  Future<Either<AppFailure, DetailedStoreEntity>> getDetailedStore(
      String token, String storeId, int pageNum);
}
