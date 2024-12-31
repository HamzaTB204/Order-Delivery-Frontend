import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';
import 'package:order_delivery/features/order/domain/repository/store_repository.dart';

class SearchStoresUseCase extends Equatable {
  final StoreRepository storeRepository;

  const SearchStoresUseCase({required this.storeRepository});

  Future<Either<AppFailure, List<StoreEntity>>> call(
      String token, String query, int pageNum) async {
    return await storeRepository.searchStores(token, query, pageNum);
  }

  @override
  List<Object?> get props => [storeRepository];
}
