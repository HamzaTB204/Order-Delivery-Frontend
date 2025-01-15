import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/constants/strings.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/features/order/data/models/product_model.dart';
import 'package:order_delivery/features/order/data/models/store_module.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_store_enitity.dart';
import 'package:http/http.dart' as http;
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';

abstract class StoreRemoteDataSource implements Equatable {
  Future<List<StoreModel>> getRandomStores(String token);
  Future<List<StoreModel>> searchStores(
      String token, String query, int pageNum);
  Future<DetailedStoreEntity> getDetailedStore(
      String token, String storeId, int pageNum);
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  final http.Client client;

  const StoreRemoteDataSourceImpl({required this.client});
  @override
  Future<List<StoreModel>> getRandomStores(String token) async {
    return await _mapGetStores("$STORE_LINK?page=1", token);
  }

  @override
  Future<List<StoreModel>> searchStores(
      String token, String query, int pageNum) async {
    return await _mapGetStores(
        "$STORE_LINK?search=$query&page=$pageNum", token);
  }

  @override
  Future<DetailedStoreEntity> getDetailedStore(
      String token, String storeId, int pageNum) async {
    try {
      final Map<String, String> headers = {"Authorization": "Bearer $token"};
      final response = await client.get(
        Uri.parse("$STORE_LINK/$storeId?page=$pageNum"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final StoreEntity store =
            StoreModel.fromJson(json.decode(response.body)['store']).toEntity();
        final List<dynamic> decodedProducts =
            json.decode(response.body)['products']['data'];

        final List<ProductModel> products = decodedProducts
            .map<ProductModel>(
              (jsonProduct) => ProductModel.fromJson(jsonProduct,
                  storeName: store.storeName),
            )
            .toList();
        return DetailedStoreEntity(store: store, products: products);
      } else {
        throw ServerException(message: "Server Error while getting stores");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(
          message: "Network Error during fetching stores: $e");
    }
  }

  Future<List<StoreModel>> _mapGetStores(String getLink, String token) async {
    try {
      final Map<String, String> headers = {"Authorization": 'Bearer $token'};
      final response = await client.get(
        Uri.parse(getLink),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body)['stores'];
        return decodedJson
            .map<StoreModel>((jsonProduct) => StoreModel.fromJson(jsonProduct))
            .toList();
      } else {
        throw ServerException(message: "Server Error while getting stores");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(
          message: "Network Error during fetching stores: $e");
    }
  }

  @override
  List<Object?> get props => [client];

  @override
  bool? get stringify => false;
}
