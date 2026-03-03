import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/notification_helper.dart';
import 'package:restaurant_flutter/common/theme.dart';
import 'package:restaurant_flutter/common/workmanager_helper.dart';
import 'package:restaurant_flutter/data/datasources/database_helper.dart';
import 'package:restaurant_flutter/data/datasources/restaurant_remote_datasource.dart';
import 'package:restaurant_flutter/data/repositories/favorite_repository_impl.dart';
import 'package:restaurant_flutter/data/repositories/restaurant_repository_impl.dart';
import 'package:restaurant_flutter/domain/usecases/favorite_usecases.dart';
import 'package:restaurant_flutter/domain/usecases/get_restaurant_list.dart';
import 'package:restaurant_flutter/presentation/pages/home_page.dart';
import 'package:restaurant_flutter/presentation/providers/favorite_provider.dart';
import 'package:restaurant_flutter/presentation/providers/reminder_provider.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_list_provider.dart';
import 'package:restaurant_flutter/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initNotifications();
  await WorkManagerHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = RestaurantRemoteDataSource();
    final repository = RestaurantRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final getRestaurantList = GetRestaurantList(repository);

    final dbHelper = DatabaseHelper();
    final favoriteRepo = FavoriteRepositoryImpl(databaseHelper: dbHelper);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(
          create: (_) => RestaurantListProvider(
            getRestaurantList: getRestaurantList,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(
            getFavorites: GetFavorites(favoriteRepo),
            addFavorite: AddFavorite(favoriteRepo),
            removeFavorite: RemoveFavorite(favoriteRepo),
            checkIsFavorite: CheckIsFavorite(favoriteRepo),
          ),
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
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
