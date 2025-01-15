class UserEntity {
  final String phoneNumber, password, token;
  final String? role, firstName, lastName, profilePictureURL, location, locale;

  UserEntity(
      {required this.phoneNumber,
      required this.role,
      required this.password,
      required this.token,
      required this.firstName,
      required this.lastName,
      required this.profilePictureURL,
      required this.location,
      required this.locale});
}
