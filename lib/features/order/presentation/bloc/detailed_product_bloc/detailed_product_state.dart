part of 'detailed_product_bloc.dart';

sealed class DetailedProductState extends Equatable {
  const DetailedProductState();

  @override
  List<Object> get props => [];
}

final class DetailedProductInitial extends DetailedProductState {}

final class LoadingGetDetailedProductState extends DetailedProductState {}

final class FailedGetDetailedProductState extends DetailedProductState {
  final AppFailure failure;

  const FailedGetDetailedProductState({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class LoadedDetailedProductState extends DetailedProductState {
  final DetailedProductEntity detailedProduct;

  const LoadedDetailedProductState({required this.detailedProduct});

  @override
  List<Object> get props => [detailedProduct];
}
