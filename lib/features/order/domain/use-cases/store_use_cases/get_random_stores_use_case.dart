import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';
import 'package:order_delivery/features/order/domain/repository/store_repository.dart';

class GetRandomStoresUseCase extends Equatable {
  final StoreRepository storeRepository;

  const GetRandomStoresUseCase({required this.storeRepository});

  Future<Either<AppFailure, List<StoreEntity>>> call(String token) async {
    return await storeRepository.getRandomStores(token);
  }

  @override
  List<Object?> get props => [storeRepository];
}
