part of 'store_pagination_bloc.dart';

@immutable
sealed class StorePaginationState extends Equatable {
  const StorePaginationState() ;

  @override
  List<Object?> get props => [];
}

final class StorePaginationInitial extends StorePaginationState {}


final class LoadingStoreState extends StorePaginationState {}


class FailedStoreState extends StorePaginationState {
  final AppFailure failure;

  const FailedStoreState({required this.failure});

  @override
  List<Object> get props => [failure];
}

class LoadedSearchStoresState extends StorePaginationState {
  final List<StoreEntity> stores;

  const LoadedSearchStoresState({required this.stores});

  @override
  List<Object> get props => [stores];
}