import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:order_delivery/core/constants/strings.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/features/order/data/models/order_model.dart';
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
  Future<List<ProductModel>> getFavProducts(String token);
  Future<List<ProductModel>> getCartProducts(String token);
  Future<void> orderFavProducts(String token);
  Future<void> orderCartProducts(String token);
  Future<List<OrderModel>> getUserOrders(String token);
  Future<void> cancelOrder(String token, String orderId);
  Future<void> deleteCart(String token, String productId);
  Future<void> deleteFav(String token, String productId);
  Future<void> updateOrder(String token, String productId, int quantity);
  Future<void> updateCart(String token, String productId, int quantity);

  // neu
  Future<List<OrderModel>> getDriverOrders(String token);
  Future<void> changeOrderStatus(
      String token, String orderId, String newStatus);
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
    return await _mapGetProducts("$PRODUCTS_LINK?page=$pageNum", token, true);
  }

  @override
  Future<List<ProductModel>> searchProducts(
      String token, String query, int pageNum) async {
    return await _mapGetProducts(
        "$PRODUCTS_LINK?search=$query&page=$pageNum", token, true);
  }

  @override
  Future<void> orderProduct(
      String token, String productId, int quantity) async {
    return await _mapVoidProducts(ORDER_LINK, token,
        body: {'product_id': productId, 'quantity': quantity.toString()});
  }

  @override
  Future<void> addProductToCart(
      String token, String productId, int quantity) async {
    return await _mapVoidProducts(CART_LINK, token,
        body: {'product_id': productId, 'quantity': quantity.toString()});
  }

  @override
  Future<void> addProductToFavorite(String token, String productId) async {
    return await _mapVoidProducts(FAV_LINK, token,
        body: {'product_id': productId});
  }

  @override
  Future<void> orderCartProducts(String token) async {
    return await _mapVoidProducts(ORDER_CART_LINK, token, get: true);
  }

  @override
  Future<void> orderFavProducts(String token) async {
    return await _mapVoidProducts(ORDER_FAV_LINK, token);
  }

  @override
  Future<void> cancelOrder(String token, String orderId) async {
    return await _mapVoidProducts('$CANCEL_ORDER_LINK/$orderId', token,
        get: true);
  }

  @override
  Future<void> deleteCart(String token, String productId) async {
    return await _mapVoidProducts("$CART_LINK/$productId", token, delete: true);
  }

  @override
  Future<void> deleteFav(String token, String productId) async {
    return await _mapVoidProducts("$FAV_LINK/$productId", token, delete: true);
  }

  @override
  Future<void> updateCart(String token, String productId, int quantity) async {
    return await _mapVoidProducts("$CART_LINK/$productId", token,
        body: {'product_id': productId, 'quantity': quantity.toString()},
        put: true);
  }

  @override
  Future<void> updateOrder(String token, String productId, int quantity) async {
    return await _mapVoidProducts("$ORDER_LINK/$productId", token,
        body: {'product_id': productId, 'quantity': quantity.toString()},
        put: true);
  }

  @override
  Future<DetailedProductEntity> getDetailedProduct(
      String token, ProductEntity product) async {
    try {
      final Map<String, String> headers = {"Authorization": "Bearer $token"};
      final response = await client.get(
        Uri.parse("$STORE_LINK/${product.storeId}?page=1"),
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
  Future<List<ProductModel>> getCartProducts(String token) async {
    try {
      final Map<String, String> headers = {"Authorization": "Bearer $token"};
      final response = await client.get(
        Uri.parse(CART_LINK),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson =
            json.decode(response.body)['Cart Product'];

        return decodedJson
            .map<ProductModel>((jsonProduct) => ProductModel.fromJson(
                jsonProduct['product'],
                quantity: jsonProduct['quantity']))
            .toList();
      } else if (response.statusCode == 404) {
        return [];
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
  Future<List<ProductModel>> getFavProducts(String token) async {
    try {
      final Map<String, String> headers = {"Authorization": "Bearer $token"};
      final response = await client.get(
        Uri.parse(FAV_LINK),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson =
            json.decode(response.body)['Favorite Product'];
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

  @override
  Future<List<OrderModel>> getUserOrders(String token) async {
    return await _mapGetOrders(ORDER_LINK, token);
  }

  @override
  Future<void> changeOrderStatus(
      String token, String orderId, String newStatus) async {
    return _mapVoidProducts("$ORDER_LINK/$orderId/status", token,
        body: {"status": newStatus});
  }

  @override
  Future<List<OrderModel>> getDriverOrders(String token) async {
    return await _mapGetOrders(DRIVER_ORDERS_LINK, token);
  }

  @override
  List<Object?> get props => [client];

  @override
  bool? get stringify => false;

  Future<List<ProductModel>> _mapGetProducts(String getLink, String token,
      [bool withData = false]) async {
    try {
      final Map<String, String> headers = {"Authorization": "Bearer $token"};
      final response = await client.get(
        Uri.parse(getLink),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = withData
            ? json.decode(response.body)['products']['data']
            : json.decode(response.body)['products'];
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

  Future<void> _mapVoidProducts(String link, String token,
      {Map<String, dynamic>? body,
      bool get = false,
      bool delete = false,
      bool put = false}) async {
    try {
      final Map<String, String> headers = {"Authorization": "Bearer $token"};
      final http.Response response;
      if (delete) {
        response = await client.delete(Uri.parse(link), headers: headers);
      } else if (get) {
        response = await client.get(Uri.parse(link), headers: headers);
      } else if (put) {
        response =
            await client.put(Uri.parse(link), headers: headers, body: body);
      } else {
        response =
            await client.post(Uri.parse(link), headers: headers, body: body);
      }
      if (response.statusCode == 200) {
        return;
      } else {
        log(response.body, error: link);
        throw ServerException(
            message: "Server Error while working with products");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      log(e.toString(), error: link);
      throw NetworkException(
          message: "Network Error during working with products: $e");
    }
  }

  Future<List<OrderModel>> _mapGetOrders(String link, String token) async {
    try {
      final Map<String, String> headers = {"Authorization": "Bearer $token"};
      final response = await client.get(
        Uri.parse(link),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body);
        return decodedJson
            .map<OrderModel>((jsonProduct) => OrderModel.fromJson(
                jsonProduct['products'],
                status: jsonProduct['order status']))
            .toList();
      } else {
        throw ServerException(message: "Server Error while getting orders");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(
          message: "Network Error during fetching orders: $e");
    }
  }
}
