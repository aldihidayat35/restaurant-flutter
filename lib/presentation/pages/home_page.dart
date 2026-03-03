import 'package:flutter/material.dart';
import 'package:restaurant_flutter/presentation/pages/favorite_page.dart';
import 'package:restaurant_flutter/presentation/pages/restaurant_list_page.dart';
import 'package:restaurant_flutter/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    RestaurantListPage(),
    FavoritePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.restaurant_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              selectedIcon: Icon(
                Icons.restaurant_rounded,
                color: theme.colorScheme.primary,
              ),
              label: 'Restaurants',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.favorite_border_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              selectedIcon: Icon(
                Icons.favorite_rounded,
                color: theme.colorScheme.primary,
              ),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              selectedIcon: Icon(
                Icons.settings_rounded,
                color: theme.colorScheme.primary,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
