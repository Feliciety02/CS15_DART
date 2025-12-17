import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'parking.db');

    // TEMP: print path so you can locate the DB
    print('DATABASE PATH: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE parking_tickets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            plate TEXT NOT NULL,
            slot TEXT NOT NULL,
            time_in TEXT NOT NULL,
            time_out TEXT,
            fee REAL
          )
        ''');
      },
    );
  }
}
