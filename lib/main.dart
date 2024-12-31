import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/core/util/theme/app_theme.dart';
import 'package:order_delivery/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:order_delivery/features/auth/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:order_delivery/features/order/presentation/pages/home_page.dart';
import 'package:order_delivery/features/auth/presentation/pages/login_page.dart';
import 'package:order_delivery/features/auth/presentation/pages/update_profile_page.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_splash_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
        body: CustomSplashScreen(
      navigate: true,
    )),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              di.sl<AuthBloc>()..add(DefineCurrentStateEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<UserBloc>(),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String? appLocal;
          Widget homePage = LoginPage();
          if (state is AuthInitial) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  body: CustomSplashScreen(
                navigate: false,
              )),
            );
          } else if (state is LoggedinAuthState) {
            // if user is logged in but profile data doesn't exist show update profile page
            if (state.user.firstName == null || state.user.firstName == '') {
              homePage = UpdateProfilePage();
            } else {
              homePage = const HomePage();
            }
            appLocal = state.user.locale;
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
                  ? (locale, supportedLocales) {
                      for (var l in supportedLocales) {
                        if (locale != null &&
                            locale.languageCode == l.languageCode) {
                          return locale;
                        }
                      }
                      return supportedLocales.first;
                    }
                  : null,
              debugShowCheckedModeBanner: false,
              theme: flexTheme.toTheme,
              home: homePage);
        },
      ),
    );
  }
}
