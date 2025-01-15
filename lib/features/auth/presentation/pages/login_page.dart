import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/util/functions/functions.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/presentation/widgets/costum_loading_widget.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final TextEditingController phoneNumberTEC = TextEditingController();

  final TextEditingController passwordTEC = TextEditingController();

  @override
  void dispose() {
    phoneNumberTEC.dispose();
    passwordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildLoginBloc(),
    );
  }

  Widget _buildLoginBloc() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedinAuthState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(
                context, Colors.grey.shade900, "logged in msg".tr(context));
          });
        } else if (state is FailedAuthState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showCustomAboutDialog(
                context, "Auth Error", state.failure.failureMessage);
          });
        }
      },
      builder: (context, state) {
        if (state is LoadingAuthState) {
          return const CustomLoadingWidget();
        } else {
          return Form(
            key: loginFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _buildAppTitle(),
                  ..._buildTextFields(),
                  _buildSubmitButton(),
                  _buildSignupButton(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSignupButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("msg1".tr(context),
            style: Theme.of(context).textTheme.displaySmall),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SignupPage()));
          },
          child: Text(
            "su".tr(context),
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Colors.greenAccent),
          ),
        )
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35, top: 185, bottom: 20),
      child: ElevatedButton(
          style: const ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Color.fromARGB(255, 45, 133, 90)),
              foregroundColor: WidgetStatePropertyAll(Colors.black),
              elevation: WidgetStatePropertyAll(7),
              shadowColor:
                  WidgetStatePropertyAll(Color.fromARGB(255, 87, 218, 82)),
              padding: WidgetStatePropertyAll(EdgeInsets.all(15))),
          onPressed: () {
            if (loginFormKey.currentState!.validate()) {
              FocusScope.of(context).unfocus();
              BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                  phoneNumber: phoneNumberTEC.text.trim(),
                  password: passwordTEC.text.trim()));
            }
          },
          child: Text(
            "LI".tr(context),
            style: Theme.of(context).textTheme.displayMedium,
          )),
    );
  }

  Widget _buildAppTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 170),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.delivery_dining_outlined,
            size: 90,
            color: Colors.greenAccent,
          ),
          Text(
            "SPEEDY SERVE",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 100, left: 13, right: 13),
        child: CustomTextFormField(
          textEditingController: phoneNumberTEC,
          validator: (value) {
            if (value!.isEmpty) {
              return "warning".tr(context);
            }
            // else if (!numberExp.hasMatch(phoneNumberTEC.text)) {
            //   return "warning3".tr(context);
            // }
            return null;
          },
          prefixIcon: const Icon(
            Icons.numbers_outlined,
            color: Colors.greenAccent,
          ),
          hintText: "pn".tr(context),
          obsecure: false,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 27, left: 13, right: 13),
        child: CustomTextFormField(
          textEditingController: passwordTEC,
          validator: (value) {
            if (value!.isEmpty) {
              return "warning".tr(context);
            }
            return null;
          },
          obsecure: true,
          hintText: "pw".tr(context),
          prefixIcon: const Icon(
            Icons.password_outlined,
            color: Colors.greenAccent,
          ),
        ),
      ),
    ];
  }
}
