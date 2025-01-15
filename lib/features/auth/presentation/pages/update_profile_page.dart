import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_delivery/core/util/functions/functions.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:order_delivery/features/auth/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:order_delivery/features/auth/presentation/widgets/costum_loading_widget.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_error_widget.dart';
import 'package:order_delivery/features/order/presentation/pages/home_page.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_text_form_field.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  File? image;
  final TextEditingController firstNameTEC = TextEditingController();
  final TextEditingController secondNameTEC = TextEditingController();
  final TextEditingController locationTEC = TextEditingController();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: _buildAppBar(),
        body: _buildUpdateProfileBloc());
  }

  Widget _buildUpdateProfileBloc() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is LoggedinAuthState) {
          return BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UpdatedUserProfileState) {
                //TODO: show appropriate done message
                showSnackBar(context, Colors.grey.shade900, "update success");
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage(user: authState.user)));
              }
            },
            builder: (context, state) {
              if (state is UpdatingUserProfileState) {
                //TODO: show appropriate loading widget
                return const CustomLoadingWidget();
              } else if (state is FailedUserState) {
                //TODO: show error message in an appropriate way
                showCustomAboutDialog(
                    context, "update pro err", state.failure.failureMessage);
              }
              return _buildUpdateProfilePage(authState.user);
            },
          );
        }
        // TODO:Return appropriate error widget
        return const CustomErrorWidget(
          msg: "",
        );
      },
    );
  }

  Widget _buildUpdateProfilePage(UserEntity user) {
    final double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Form(
        key: updateFormKey,
        child: SizedBox(
          height: 0.9 * height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildFirstSection(user),
              _buildFinishButton(user.token),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstSection(UserEntity user) {
    return Column(
      children: [
        _buildTitle1(),
        _buildAddPicture(),
        _buildTitle2(),
        ..._buildTextFields(),
        _buildSkipButton(user),
      ],
    );
  }

  Widget _buildFinishButton(String userToken) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30, right: 20, left: 20),
            child: OutlinedButton(
                onPressed: () {
                  if (updateFormKey.currentState!.validate()) {
                    BlocProvider.of<UserBloc>(context).add(
                        UpdateUserProfileEvent(
                            firstName: firstNameTEC.text.trim(),
                            lastName: secondNameTEC.text.trim(),
                            location: locationTEC.text.trim(),
                            token: userToken,
                            image: image));
                  }
                },
                style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    foregroundColor: const WidgetStatePropertyAll(Colors.black),
                    backgroundColor: const WidgetStatePropertyAll(
                        Color.fromARGB(255, 19, 184, 104))),
                child: Text(
                  "finish".tr(context),
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildSkipButton(UserEntity user) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
          ),
          OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage(user: user)));
              },
              style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  foregroundColor: const WidgetStatePropertyAll(Colors.black),
                  backgroundColor: const WidgetStatePropertyAll(
                      Color.fromARGB(255, 35, 184, 112))),
              child: Text("skip".tr(context),
                  style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(8),
        child: CustomTextFormField(
          textEditingController: firstNameTEC,
          validator: (value) {
            if (value!.isEmpty) {
              return "warning".tr(context);
            }
            return null;
          },
          // TODO: localize hint text
          hintText: "first name".tr(context),
          prefixIcon: const Icon(
            Icons.man,
            color: Colors.greenAccent,
          ),
          obsecure: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: CustomTextFormField(
          textEditingController: secondNameTEC,
          validator: (value) {
            if (value!.isEmpty) {
              return "warning".tr(context);
            }
            return null;
          },
          //TODO: localize hint text
          hintText: "last name".tr(context),
          obsecure: false,
          prefixIcon: const Icon(
            Icons.man_2,
            color: Colors.greenAccent,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: CustomTextFormField(
          textEditingController: locationTEC,
          validator: (value) {
            if (value!.isEmpty) {
              return "warning".tr(context);
            }
            return null;
          },
          //TODO: localize hint text
          hintText: "location".tr(context),
          obsecure: false,
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: Colors.greenAccent,
          ),
        ),
      )
    ];
  }

  Widget _buildAddPicture() {
    return Center(
        child: Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
            child: image == null
                ? Container(
                    color: Colors.grey,
                    width: 160,
                    height: 160,
                    child: IconButton(
                        onPressed: () {
                          showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(90, 260, 90, 0),
                              items: [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.folder,
                                      color: Colors.green,
                                    ),
                                    title: Text("from gallery".tr(context)),
                                  ),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                  },
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.camera,
                                      color: Colors.green,
                                    ),
                                    title: Text("from camera".tr(context)),
                                  ),
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                  },
                                ),
                              ]);
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.greenAccent,
                        )),
                  )
                : SizedBox(
                    height: 160,
                    width: 160,
                    child: Image.file(image!),
                  )),
        Positioned(
          left: 110,
          right: 0,
          top: 120,
          child: ClipOval(
            child: Container(
              color: Colors.greenAccent,
              height: 50,
              width: 50,
              child: IconButton(
                  onPressed: () {
                    showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(90, 260, 90, 0),
                        items: [
                          PopupMenuItem(
                            child: ListTile(
                              leading: const Icon(
                                Icons.folder,
                                color: Colors.green,
                              ),
                              title: Text("from gallery".tr(context)),
                            ),
                            onTap: () {
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: const Icon(
                                Icons.camera,
                                color: Colors.green,
                              ),
                              title: Text("from camera".tr(context)),
                            ),
                            onTap: () {
                              _pickImage(ImageSource.camera);
                            },
                          ),
                        ]);
                  },
                  icon: const Icon(
                    Icons.add_a_photo_outlined,
                    size: 30,
                    color: Colors.black,
                  )),
            ),
          ),
        )
      ],
    ));
  }

  Widget _buildTitle2() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 50),
      child: Text(
        "extra info".tr(context),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildTitle1() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Text(
        "profile".tr(context),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        "update profile".tr(context),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Future _pickImage(ImageSource source) async {
    var selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage == null) return;
    setState(() {
      image = File(selectedImage.path);
    });
  }
}
