part of 'store_pagination_bloc.dart';

@immutable
sealed class StorePaginationEvent extends Equatable {
  const StorePaginationEvent();

  @override
  List<Object> get props => [];
}

class SearchStoresEvent extends StorePaginationEvent {
  final String token, query;
  final int pageNum;

  const SearchStoresEvent(
      {required this.token, required this.query, required this.pageNum});

  @override
  List<Object> get props => [token, query, pageNum];
}
