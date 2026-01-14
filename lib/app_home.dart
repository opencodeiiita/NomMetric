import 'package:flutter/material.dart';
import 'package:nommetric/screens/homeScreen_Krishna.dart';
import 'package:nommetric/screens/profileScreen_vibhu.dart';

/// AppHome serves as the main shell for the post-login app flow.
/// It manages navigation between Home and Profile screens using bottom navigation.
class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  // Track the current tab index
  int _currentIndex = 0;

  // Map to screens: 0=Home, 2=Profile (skips Menu at index 1)
  late final Map<int, Widget> _screenMap;

  @override
  void initState() {
    super.initState();
    _screenMap = {
      0: const HomeScreenKrishna(),
      2: const ProfileScreenVibhu(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenMap[_currentIndex] ?? const HomeScreenKrishna(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          // Handle tab selection:
          // 0 = Home, 1 = Menu (redirect to Home), 2 = Profile
          int mappedIndex = index;
          if (index == 1) {
            mappedIndex = 0; // Menu redirects to Home
          }
          setState(() {
            _currentIndex = mappedIndex;
          });
        },
        elevation: 3.0,
        backgroundColor: Colors.white,
        indicatorColor: Colors.blue.shade100,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            selectedIcon: Icon(Icons.restaurant_menu_rounded),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
