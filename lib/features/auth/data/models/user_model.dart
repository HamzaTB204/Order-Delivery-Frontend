import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String phoneNumber,
    required String password,
    required String token,
    required String? firstName,
    required String? lastName,
    required String? profilePictureURL,
    required String? location,
    required String? local,
  }) : super(
          phoneNumber: phoneNumber,
          password: password,
          token: token,
          firstName: firstName,
          lastName: lastName,
          profilePictureURL: profilePictureURL,
          location: location,
          local: local,
        );

  // Method to create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phoneNumber: json['phone_number'],
      password: json['password'],
      token: json['token'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePictureURL: json['profile_picture_url'],
      location: json['location'],
      local: json['local'],
    );
  }

  // Method to convert a UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'password': password,
      'token': token,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture_url': profilePictureURL,
      'location': location,
      'local': local,
    };
  }
}
