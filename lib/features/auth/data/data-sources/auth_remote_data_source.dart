import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:order_delivery/core/constants/strings.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/features/auth/data/models/user_model.dart';

// ! we need to add this to the request header 'Authorization': 'Bearer 3|u88Nk275L4YGOCnk1Mt50zl79OfTFgDIUrmxPauxb1963953',

abstract class AuthRemoteDataSource extends Equatable {
  Future<void> signup(String phoneNumber, String password);
  Future<UserModel> login(String phoneNumber, String password);
  Future<bool> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<void> signup(String phoneNumber, String password) async {
    try {
      final response = await client.post(Uri.parse(SIGNUP_LINK), body: {
        'phone': phoneNumber,
        'password': password,
      });

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        return;
      } else if (response.statusCode == 405) {
        throw ServerException(message: "Wrong phone number or password");
      } else {
        throw ServerException(message: "Server Error while Signing up");
      }
    } on ServerException catch (se) {
      throw NetworkException(
          message: "Network Error during signup: ${se.message}");
    } catch (e) {
      throw NetworkException(message: "Network Error during signup: $e");
    }
  }

  @override
  Future<UserModel> login(String phoneNumber, String password) async {
    try {
      final response = await client.post(
        Uri.parse(LOGIN_LINK),
        body: {
          'phone': phoneNumber,
          'password': password,
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        final decodedRequest = json.decode(response.body);
        final UserModel user =
            UserModel.fromJson(decodedRequest['user'], password);
        return user;
      } else if (response.statusCode == 401) {
        throw ServerException(message: "Wrong phone number or password");
      } else {
        throw ServerException(message: "Server Error while logging in");
      }
    } on ServerException catch (se) {
      throw NetworkException(
          message: "Network Error during login: ${se.message}");
    } catch (e) {
      throw NetworkException(message: "Network Error during login: $e");
    }
  }

  @override
  Future<bool> logout(String token) async {
    try {
      final response = await client.post(
        Uri.parse(LOGOUT_LINK),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException(message: "Server Error while logging out");
      }
    } on ServerException catch (se) {
      throw NetworkException(
          message: "Network Error during logout: ${se.message}");
    } catch (e) {
      throw NetworkException(message: "Network Error during logout: $e");
    }
  }

  @override
  List<Object?> get props => [client];

  @override
  bool? get stringify => false;
}
