import 'package:flutter/material.dart';
import 'package:order_delivery/features/order/presentation/pages/feed_page.dart';
import 'package:order_delivery/features/order/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navbarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: _appPages().elementAt(_navbarIndex),
          bottomNavigationBar: _buildBottomNavBar()),
    );
  }

  List<Widget> _appPages() {
    return <Widget>[FeedPage(), SettingsPage()];
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _navbarIndex,
      onTap: (value) => _changeNavbarIndex(value),
      items: _buildNavbarItems(),
      elevation: 1,
      selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).colorScheme.secondary),
      unselectedLabelStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.surface.withAlpha(150)),
      selectedIconTheme:
          IconThemeData(color: Theme.of(context).colorScheme.primary, size: 30),
      unselectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.surface.withAlpha(150),
          size: 20),
    );
  }

  void _changeNavbarIndex(int value) {
    setState(() {
      _navbarIndex = value;
    });
  }

  List<BottomNavigationBarItem> _buildNavbarItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
        icon: Icon(
          Icons.home,
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(150),
        icon: Icon(Icons.settings,
            color: Theme.of(context).colorScheme.secondary),
        label: 'Settings',
      ),
    ];
  }
}
