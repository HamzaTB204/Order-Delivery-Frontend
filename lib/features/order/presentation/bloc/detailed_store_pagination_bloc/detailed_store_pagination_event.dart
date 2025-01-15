part of 'detailed_store_pagination_bloc.dart';

@immutable
sealed class DetailedStorePaginationEvent extends Equatable {
  const DetailedStorePaginationEvent();

  @override
  List<Object?> get props => [];
}

class GetDetailedStoreEvent extends DetailedStorePaginationEvent {
  final String token, storeId;
  final int pageNum;

  const GetDetailedStoreEvent(
      {required this.token, required this.storeId, required this.pageNum});

  @override
  List<Object> get props => [token, storeId, pageNum];
}
