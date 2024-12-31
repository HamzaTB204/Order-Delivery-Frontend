part of 'store_bloc.dart';

sealed class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object> get props => [];
}

final class StoreInitial extends StoreState {}

final class LoadingStoreState extends StoreState {}

class FailedStoreState extends StoreState {
  final AppFailure failure;

  const FailedStoreState({required this.failure});

  @override
  List<Object> get props => [failure];
}

class LoadedRandomStoresState extends StoreState {
  final List<StoreEntity> stores;

  const LoadedRandomStoresState({required this.stores});

  @override
  List<Object> get props => [stores];
}

class LoadedSearchStoresState extends StoreState {
  final List<StoreEntity> stores;

  const LoadedSearchStoresState({required this.stores});

  @override
  List<Object> get props => [stores];
}

class LoadedDetailedStoreState extends StoreState {
  final DetailedStoreEntity detailedStore;

  const LoadedDetailedStoreState({required this.detailedStore});

  @override
  List<Object> get props => [detailedStore];
}
