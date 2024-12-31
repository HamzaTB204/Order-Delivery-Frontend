import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_store_enitity.dart';
import 'package:order_delivery/features/order/domain/repository/store_repository.dart';

class GetDetailedStoreUseCase extends Equatable {
  final StoreRepository storeRepository;

  const GetDetailedStoreUseCase({required this.storeRepository});

  Future<Either<AppFailure, DetailedStoreEntity>> call(
      String token, String storeId, int pageNum) async {
    return await storeRepository.getDetailedStore(token, storeId, pageNum);
  }

  @override
  List<Object?> get props => [storeRepository];
}
