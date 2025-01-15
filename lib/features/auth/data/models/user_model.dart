import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.phoneNumber,
    required super.password,
    required super.token,
    required super.role,
    required super.firstName,
    required super.lastName,
    required super.profilePictureURL,
    required super.location,
    required super.locale,
  });

  // Method to create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json, [String? password]) {
    return UserModel(
      phoneNumber: json['phone'],
      password: password ?? json['password'],
      token: json['token'],
      role: json['role'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePictureURL: json['profile_picture'],
      location: json['location'],
      locale: json['locale'],
    );
  }

  // Method to convert a UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'phone': phoneNumber,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePictureURL,
      'location': location,
      'locale': locale,
      'role': role,
      'token': token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
        phoneNumber: phoneNumber,
        password: password,
        token: token,
        firstName: firstName,
        lastName: lastName,
        role: role,
        profilePictureURL: profilePictureURL,
        location: location,
        locale: locale);
  }
}
