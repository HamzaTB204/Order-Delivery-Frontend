part of 'store_bloc.dart';

sealed class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

class GetRandomStoresEvent extends StoreEvent {
  final String token;

  const GetRandomStoresEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class SearchStoresEvent extends StoreEvent {
  final String token, query;
  final int pageNum;

  const SearchStoresEvent(
      {required this.token, required this.query, required this.pageNum});

  @override
  List<Object> get props => [token, query, pageNum];
}

class GetDetailedStoreEvent extends StoreEvent {
  final String token, storeId;
  final int pageNum;

  const GetDetailedStoreEvent(
      {required this.token, required this.storeId, required this.pageNum});

  @override
  List<Object> get props => [token, storeId, pageNum];
}
