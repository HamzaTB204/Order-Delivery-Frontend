import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:order_delivery/features/auth/presentation/pages/home_page.dart';
import 'package:order_delivery/features/auth/presentation/pages/login_page.dart';
import 'package:order_delivery/features/auth/presentation/pages/update_profile_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => di.sl<AuthBloc>()..add(DefineCurrentStateEvent()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String? appLocal;
          Widget homePage = const LoginPage();
          if (state is LoadingAuthState) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            );
          } else if (state is LoggedinAuthState) {
            // if user is logged in but profile data doesn't exist show update profile page
            if (state.user.firstName == null) {
              homePage = const UpdateProfilePage();
            } else {
              homePage = const HomePage();
            }
            final userLocale = state.user.local;
            if (userLocale != null) {
              appLocal = userLocale;
            }
          }
          return MaterialApp(
              locale: appLocal == null ? null : Locale(appLocal),
              supportedLocales: AppLocalizations.supportedLocals,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              localeResolutionCallback: appLocal == null
                  ? (locale, supportedLocales) =>
                      _getDefaultLocale(locale, supportedLocales)
                  : null,
              debugShowCheckedModeBanner: false,
              home: homePage);
        },
      ),
    );
  }

  Locale? _getDefaultLocale(locale, supportedLocales) {
    for (var l in supportedLocales) {
      if (locale != null && locale.languageCode == l.languageCode) {
        return locale;
      }
    }
    return supportedLocales.first;
  }
}
