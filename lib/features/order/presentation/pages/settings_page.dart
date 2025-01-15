import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:order_delivery/features/auth/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:order_delivery/features/auth/presentation/pages/update_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLocal = 'en';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedinAuthState) {
          selectedLocal = state.user.locale ?? "en";
        }
      },
      builder: (context, state) {
        if (state is LoggedinAuthState) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                state.user.role == 'driver'
                    ? SizedBox(
                        height: 10,
                      )
                    : SizedBox(
                        height: 0.4 * height,
                        child: (state.user.firstName == null ||
                                state.user.firstName == "")
                            ? _buildAddUserDataBtn()
                            : _buildUserData(state.user),
                      ),
                SizedBox(
                    height: 0.25 * height,
                    child: _buildChangeLangBloc(state.user)),
                SizedBox(
                    height: 0.25 * height,
                    child: _buildLogoutBtn(state.user.token)),
              ],
            ),
          );
        } else if (state is LoadingAuthState) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          );
        } else if (state is FailedAuthState) {
          return Center(
            child: Text(
              state.failure.failureMessage,
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        return Text("Error Occured");
      },
    );
  }

  Widget _buildUserData(UserEntity user) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: CircleAvatar(
              radius: 100,
              foregroundImage: NetworkImage(user.profilePictureURL!),
            ),
          ),
        ),
        Text("${user.firstName} ${user.lastName}")
      ],
    );
  }

  Widget _buildAddUserDataBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListTile(
        title: Text(
          "Missed Data",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        leading: const Icon(
          Icons.error,
          color: Colors.red,
          size: 40,
        ),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const UpdateProfilePage())),
        subtitle: const Text("click here to set up profile",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.green)),
      ),
    );
  }

  Widget _buildChangeLangBloc(UserEntity user) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is ChangedUserLanguageState) {
          BlocProvider.of<AuthBloc>(context).add(DefineCurrentStateEvent());
        }
      },
      builder: (context, state) {
        if (state is ChangingUserLanguageState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          );
        } else if (state is FailedUserState) {
          return Center(
            child: Text(
              state.failure.failureMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return _buildSettingsPage(user);
      },
    );
  }

  Widget _buildSettingsPage(UserEntity user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildChangeLangRadioBtn(),
        _buildChangeLangBtn(user.token, user.locale ?? 'en'),
      ],
    );
  }

  Widget _buildChangeLangBtn(String token, String userLocal) {
    return MaterialButton(
        height: 50,
        color: selectedLocal == userLocal ? Colors.black : Colors.blue,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        onPressed: (selectedLocal != userLocal)
            ? () {
                BlocProvider.of<UserBloc>(context).add(ChangeUserLanguageEvent(
                    token: token, locale: selectedLocal));
              }
            : null,
        child: Text(
          "Change Language",
          style: Theme.of(context).textTheme.bodyMedium,
        ));
  }

  Widget _buildChangeLangRadioBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("syl".tr(context)),
        RadioListTile<String>(
          activeColor: Colors.blue,
          title: Text('en'.tr(context),
              style: Theme.of(context).textTheme.bodyMedium),
          value: 'en',
          groupValue: selectedLocal,
          onChanged: (value) => _selectLang(value),
        ),
        RadioListTile<String>(
            activeColor: Colors.blue,
            title: Text("ar".tr(context),
                style: Theme.of(context).textTheme.bodyMedium),
            value: 'ar',
            groupValue: selectedLocal,
            onChanged: (value) => _selectLang(value)),
      ],
    );
  }

  Widget _buildLogoutBtn(String token) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: MaterialButton(
                height: 50,
                color: Colors.green,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(LogoutEvent(token: token));
                },
                child: Text(
                  "Logout",
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
          ),
        ),
      ],
    );
  }

  void _selectLang(value) {
    if (value != null) {
      selectedLocal = value;
      setState(() {});
    }
  }
}
