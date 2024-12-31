import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:order_delivery/core/constants/strings.dart';
import 'package:order_delivery/core/errors/errors.dart';

abstract class UserRemoteDataSource extends Equatable {
  Future<String> updateProfile(String firstName, String lastName, File? image,
      String location, String token);
  Future<String> changeLanguage(String token, String locale);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  const UserRemoteDataSourceImpl({required this.client});
  @override
  Future<String> updateProfile(String firstName, String lastName, File? image,
      String location, String token) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(UPDATE_PROFILE_LINK),
      );

      request.headers['Authorization'] = 'Bearer $token';
      // Add text fields
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['location'] = location;

      // Add image file (if provided)
      if (image != null) {
        final imageFile = await http.MultipartFile.fromPath(
          'profile_picture',
          image.path,
          filename: image.path,
        );
        request.files.add(imageFile);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);
        return responseData['user']['profile_picture'];
      } else {
        throw ServerException(
            message: "Server error while updating user profile data");
      }
    } catch (e) {
      throw NetworkException(
          message: "Network Error while updating user profile data: $e");
    }
  }

  @override
  Future<String> changeLanguage(String token, String locale) async {
    try {
      final response = await client.post(Uri.parse(CHANGE_LANG_LINK),
          headers: {'Authorization': 'Bearer $token'},
          body: {'locale': locale});
      if (response.statusCode >= 200 || response.statusCode <= 300) {
        return jsonDecode(response.body)['locale'];
      } else {
        throw ServerException(
            message:
                "Server Error while changing language:${response.reasonPhrase}");
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(
          message: "Network Error during posting products: $e");
    }
  }

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}
