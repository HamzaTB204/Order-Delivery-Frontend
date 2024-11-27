import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:order_delivery/features/auth/data/models/user_model.dart';
import 'package:order_delivery/core/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource extends Equatable {
  Future<UserModel?> loadUser();
  Future<void> storeUser(UserModel? user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  const UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> storeUser(UserModel? user) async {
    if (user != null) {
      String jsonEndcoded = json.encode(user.toJson());
      await sharedPreferences.setString(USER_KEY, jsonEndcoded);
    } else {
      await sharedPreferences.setString(USER_KEY, "");
    }
  }

  @override
  Future<UserModel?> loadUser() async {
    final String? jsonString = sharedPreferences.getString(USER_KEY);
    if (jsonString != null) {
      final Map<String, dynamic> decodedJson = json.decode(jsonString);
      return UserModel.fromJson(decodedJson);
    } else {
      return null;
    }
  }

  @override
  List<Object?> get props => [sharedPreferences];

  @override
  bool? get stringify => false;
}
