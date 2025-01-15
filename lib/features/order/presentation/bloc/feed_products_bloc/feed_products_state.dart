part of 'feed_products_bloc.dart';

sealed class FeedProductsState extends Equatable {
  const FeedProductsState();

  @override
  List<Object> get props => [];
}

final class FeedProductsInitial extends FeedProductsState {}

final class LoadingGetFeedPageProductsState extends FeedProductsState {}

final class FailedGetFeedPageProductsState extends FeedProductsState {
  final AppFailure failure;

  const FailedGetFeedPageProductsState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class LoadedFeedPageProductsState extends FeedProductsState {
  final List<ProductEntity> latest;
  final List<ProductEntity> topDemand;

  const LoadedFeedPageProductsState(
      {required this.latest, required this.topDemand});
  @override
  List<Object> get props => [latest, topDemand];
}
