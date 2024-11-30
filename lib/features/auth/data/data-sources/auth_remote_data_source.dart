import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:order_delivery/core/constants/strings.dart';
import 'package:order_delivery/core/errors/errors.dart';
import 'package:order_delivery/features/auth/data/models/user_model.dart';

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
        'phoneNumber': phoneNumber,
        'password': password,
      });

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 405) {
        throw ServerException(message: "Wrong phone number or password");
      } else {
        throw ServerException(message: "Server Error while Signing up");
      }
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
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final UserModel user = UserModel.fromJson(json.decode(response.body));
        return user;
      } else if (response.statusCode == 406) {
        throw ServerException(message: "Wrong phone number or password");
      } else {
        throw ServerException(message: "Server Error while logging in");
      }
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
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final bool isLoggedout = responseBody['status'] as bool;

        return isLoggedout;
      } else {
        throw ServerException(message: "Server Error while logging out");
      }
    } catch (e) {
      throw NetworkException(message: "Network Error while logging out");
    }
  }

  @override
  List<Object?> get props => [client];

  @override
  bool? get stringify => false;
}
