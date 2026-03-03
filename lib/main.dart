import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/theme.dart';
import 'package:restaurant_flutter/data/datasources/restaurant_remote_datasource.dart';
import 'package:restaurant_flutter/data/repositories/restaurant_repository_impl.dart';
import 'package:restaurant_flutter/domain/usecases/get_restaurant_list.dart';
import 'package:restaurant_flutter/presentation/pages/restaurant_list_page.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_list_provider.dart';
import 'package:restaurant_flutter/presentation/providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup dependency injection
    final remoteDataSource = RestaurantRemoteDataSource();
    final repository = RestaurantRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final getRestaurantList = GetRestaurantList(repository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              RestaurantListProvider(getRestaurantList: getRestaurantList),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Restaurant App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const RestaurantListPage(),
          );
        },
      ),
    );
  }
}
