part of 'feed_products_bloc.dart';

sealed class FeedProductsEvent extends Equatable {
  const FeedProductsEvent();

  @override
  List<Object> get props => [];
}

class GetFeedPageProductsEvent extends FeedProductsEvent {
  final String token;

  const GetFeedPageProductsEvent({required this.token});
  @override
  List<Object> get props => [token];
}
