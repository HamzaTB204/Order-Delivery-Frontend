import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/constants/strings.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/features/order/data/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:order_delivery/features/order/data/models/store_module.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_product.entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';

abstract class ProductRemoteDataSource implements Equatable {
  Future<List<ProductModel>> getTopDemandProducts(String token);
  Future<List<ProductModel>> getLatestProducts(String token);
  Future<List<ProductModel>> getRandomProducts(String token, int pageNum);
  Future<List<ProductModel>> searchProducts(
      String token, String query, int pageNum);

  Future<DetailedProductEntity> getDetailedProduct(
      String token, ProductEntity product);
  Future<void> orderProduct(String token, String productId, int quantity);
  Future<void> addProductToFavorite(String token, String productId);
  Future<void> addProductToCart(String token, String productId, int quantity);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  const ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getTopDemandProducts(String token) async {
    return await _mapGetProducts(TOP_DEMAND_PRODUCTS_LINK, token);
  }

  @override
  Future<List<ProductModel>> getLatestProducts(String token) async {
    return await _mapGetProducts(LATEST_PRODUCTS_LINK, token);
  }

  @override
  Future<List<ProductModel>> getRandomProducts(
      String token, int pageNum) async {
    return await _mapGetProducts("$RANDOM_PRODUCTS_LINK?page=$pageNum", token);
  }

  @override
  Future<List<ProductModel>> searchProducts(
      String token, String query, int pageNum) async {
    return await _mapGetProducts(
        "$SEARCH_PRODUCTS_LINK?search=$query&page=$pageNum", token);
  }

  @override
  Future<DetailedProductEntity> getDetailedProduct(
      String token, ProductEntity product) async {
    try {
      final Map<String, String> headers = {"Authorization": token};
      final response = await client.get(
        Uri.parse("$DETAILED_STORE_LINK/${product.storeId}?page=1"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final StoreEntity store =
            StoreModel.fromJson(json.decode(response.body)['store']).toEntity();
        return DetailedProductEntity(store: store, product: product);
      } else {
        throw ServerException(message: "Server Error while getting products");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(
          message: "Network Error during fetching products: $e");
    }
  }

  @override
  Future<void> orderProduct(
      String token, String productId, int quantity) async {
    return await _mapPostProducts(ORDER_PRODUCT_LINK, token,
        {'product_id': productId, 'quantity': quantity});
  }

  @override
  Future<void> addProductToCart(
      String token, String productId, int quantity) async {
    return await _mapPostProducts(ADD_PRODUCT_TO_CART_LINK, token,
        {'product_id': productId, 'quantity': quantity});
  }

  @override
  Future<void> addProductToFavorite(String token, String productId) async {
    return await _mapPostProducts(
        ORDER_PRODUCT_LINK, token, {'product_id': productId});
  }

  @override
  List<Object?> get props => [client];

  @override
  bool? get stringify => false;

  Future<List<ProductModel>> _mapGetProducts(
      String getLink, String token) async {
    try {
      final Map<String, String> headers = {"Authorization": token};
      final response = await client.get(
        Uri.parse(getLink),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson =
            json.decode(response.body)['products']['data'];
        return decodedJson
            .map<ProductModel>(
                (jsonProduct) => ProductModel.fromJson(jsonProduct))
            .toList();
      } else {
        throw ServerException(message: "Server Error while getting products");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(
          message: "Network Error during fetching products: $e");
    }
  }

  Future<void> _mapPostProducts(
      String postLink, String token, Map<String, dynamic> body) async {
    try {
      final Map<String, String> headers = {"Authorization": token};
      final response =
          await client.post(Uri.parse(postLink), headers: headers, body: body);
      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(message: "Server Error while posting products");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(
          message: "Network Error during posting products: $e");
    }
  }
}
