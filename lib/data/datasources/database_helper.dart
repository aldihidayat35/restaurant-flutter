import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableFavorite = 'favorites';

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'restaurant_favorite.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableFavorite (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      _tableFavorite,
      {
        'id': restaurant.id,
        'name': restaurant.name,
        'description': restaurant.description,
        'pictureId': restaurant.pictureId,
        'city': restaurant.city,
        'rating': restaurant.rating,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final results = await db.query(_tableFavorite);
    return results
        .map(
          (map) => Restaurant(
            id: map['id'] as String,
            name: map['name'] as String,
            description: map['description'] as String,
            pictureId: map['pictureId'] as String,
            city: map['city'] as String,
            rating: map['rating'] as double,
          ),
        )
        .toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final results = await db.query(
      _tableFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty;
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableFavorite, where: 'id = ?', whereArgs: [id]);
  }
}
