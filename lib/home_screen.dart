import 'package:flutter/material.dart';
import 'package:gdg_campus_coffee/branches/presentation/view/branches_screen.dart';
import 'package:gdg_campus_coffee/core/theme/app_theme.dart';
import 'package:gdg_campus_coffee/market/presentation/view/market_screen.dart';
import 'package:gdg_campus_coffee/menu/presentation/view/menu_screen.dart';
import 'package:gdg_campus_coffee/recommendation/presentation/view/recommendation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.navBg,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() => currentPageIndex = index);
          },
          indicatorColor: Colors.transparent,
          backgroundColor: AppColors.navBg,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.coffee_outlined),
              selectedIcon: Icon(Icons.coffee),
              label: 'Menu',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag),
              label: 'Shop',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: 'Assistant',
            ),
          ],
        ),
      ),
      body: <Widget>[
        const MenuScreen(),
        const BranchesScreen(),
        const MarketScreen(),
        const RecommendationScreen(),
      ][currentPageIndex],
    );
  }
}
