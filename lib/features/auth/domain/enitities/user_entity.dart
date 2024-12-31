class UserEntity {
  final String phoneNumber, password, token;
  final String? firstName, lastName, profilePictureURL, location, locale;

  UserEntity(
      {required this.phoneNumber,
      required this.password,
      required this.token,
      required this.firstName,
      required this.lastName,
      required this.profilePictureURL,
      required this.location,
      required this.locale});
}
