import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/util/variables/others.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_text_form_field.dart';
import '../../../../core/util/lang/app_localizations.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

//valid num 123-456-7890
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> signupFormKey = GlobalKey();

  final TextEditingController phoneNumberTEC = TextEditingController();

  final TextEditingController passwordTEC = TextEditingController();

  final TextEditingController confirmedPasswordTEC = TextEditingController();
  @override
  void dispose() {
    phoneNumberTEC.dispose();
    passwordTEC.dispose();
    confirmedPasswordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          foregroundColor: Colors.white,
        ),
        body: _buildSignupBloc());
  }

  Widget _buildSignupBloc() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignedupAuthState) {
          // TODO: show singed up message
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is LoadingAuthState) {
          //TODO: show appropriate loading widget
          return Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          );
        } else if (state is FailedAuthState) {
          //TODO: show error message in an appropriate way
          return Center(
            child: Text(state.failure.failureMessage,
                style: TextStyle(color: Colors.red)),
          );
        }
        return Form(
          key: signupFormKey,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildAppTitle(),
                ..._buildTextFields(),
                _buildSubmitButton(),
                _buildLoginButton()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("msg2".tr(context),
            style: Theme.of(context).textTheme.displaySmall),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "li".tr(context),
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
      padding: const EdgeInsets.only(left: 35, right: 35, top: 100, bottom: 20),
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
            if (signupFormKey.currentState!.validate()) {
              BlocProvider.of<AuthBloc>(context).add(SignupEvent(
                  phoneNumber: phoneNumberTEC.text.trim(),
                  password: passwordTEC.text.trim()));
            }
          },
          child: Text(
            "SU".tr(context),
            style: Theme.of(context).textTheme.displayMedium,
          )),
    );
  }

  Widget _buildAppTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Text(
              "welcome".tr(context),
              style: Theme.of(context).textTheme.bodyLarge,
            )),
        Text("create".tr(context),
            style: Theme.of(context).textTheme.bodyMedium)
      ],
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
              } else if (!numberExp.hasMatch(phoneNumberTEC.text.trim())) {
                return "warning3".tr(context);
              }
              return null;
            },
            hintText: "pn".tr(context),
            obsecure: false,
            prefixIcon: const Icon(
              Icons.numbers_outlined,
              color: Colors.greenAccent,
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 27, left: 13, right: 13),
        child: CustomTextFormField(
          textEditingController: passwordTEC,
          obsecure: true,
          validator: (value) {
            if (value!.isEmpty) {
              return "warning".tr(context);
            }
            return null;
          },
          hintText: "pw".tr(context),
          prefixIcon: const Icon(
            Icons.password_outlined,
            color: Colors.greenAccent,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 27, left: 13, right: 13),
        child: CustomTextFormField(
          textEditingController: confirmedPasswordTEC,
          validator: (value) {
            if (value!.isEmpty) {
              return "warning".tr(context);
            } else if (passwordTEC.text.trim() !=
                confirmedPasswordTEC.text.trim()) {
              return "warning2".tr(context);
            }
            return null;
          },
          obsecure: true,
          hintText: "cpw".tr(context),
          prefixIcon: const Icon(
            Icons.password_outlined,
            color: Colors.greenAccent,
          ),
        ),
      ),
    ];
  }
}
