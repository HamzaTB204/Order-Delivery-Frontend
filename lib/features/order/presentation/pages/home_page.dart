import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:order_delivery/features/order/presentation/pages/cart_page.dart';
import 'package:order_delivery/features/order/presentation/pages/driver_feed_page.dart';
import 'package:order_delivery/features/order/presentation/pages/favorite_page.dart';
import 'package:order_delivery/features/order/presentation/pages/order_page.dart';
import 'package:order_delivery/features/order/presentation/pages/search_page.dart';
import 'package:order_delivery/features/order/presentation/pages/user_feed_page.dart';
import 'package:order_delivery/features/order/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  final UserEntity user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navbarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: _homeAppBar(context),
          body: _appPages().elementAt(_navbarIndex),
          bottomNavigationBar: _buildBottomNavBar()),
    );
  }

  List<Widget> _appPages() {
    UserEntity user = widget.user;
    if (user.role == "user") {
      return <Widget>[
        UserFeedPage(user: user),
        CartPage(user: user),
        OrderPage(user: user),
        const SettingsPage()
      ];
    } else {
      return <Widget>[
        DriverFeedPage(
          user: user,
        ),
        SettingsPage()
      ];
    }
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _navbarIndex,
      onTap: (value) => _changeNavbarIndex(value),
      items: _buildNavbarItems(),
      elevation: 1,
      fixedColor: Colors.white,
      selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary),
      unselectedLabelStyle:
          TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
      selectedIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.primary, size: 30),
      unselectedIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.primary, size: 20),
    );
  }

  void _changeNavbarIndex(int value) {
    setState(() {
      _navbarIndex = value;
    });
  }

  List<BottomNavigationBarItem> _buildNavbarItems() {
    if (widget.user.role == "user") {
      return <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
          icon: Icon(
            Icons.home,
            color: Colors.deepOrange,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.amber,
          ),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
          icon: Icon(
            Icons.list_alt_sharp,
            color: Colors.blue,
          ),
          label: 'Order',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
          icon: Icon(Icons.settings, color: Colors.white),
          label: 'Settings',
        ),
      ];
    } else {
      return <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
          icon: Icon(
            Icons.home,
            color: Colors.deepOrange,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
          icon: Icon(Icons.settings, color: Colors.white),
          label: 'Settings',
        ),
      ];
    }
  }

  AppBar _homeAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
      foregroundColor: Colors.white,
      title: Text(
        "SPEEDY SERVE",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: widget.user.role == 'driver'
          ? null
          : [
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is LoggedinAuthState) {
                  return IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FavoritePage(
                                  user: state.user,
                                )));
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.pink,
                        size: 40,
                      ));
                }
                return SizedBox();
              }),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is LoggedinAuthState) {
                  return IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchPage(
                                  user: state.user,
                                )));
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.blue,
                        size: 40,
                      ));
                }
                return SizedBox();
              })
            ],
    );
  }
}
