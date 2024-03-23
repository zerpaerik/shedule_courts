import 'package:sqflite/sqflite.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

import '../model/schedule.dart';

class DBHelper {
  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE schedule(
        id INTEGER PRIMARY KEY NOT NULL, 
        court TEXT, 
        userSchedule TEXT, 
        isActive BOOLEAN,
        dateSchedule DATETIME
        )""");
  }

  static Future<Database> openDB() async {
    return openDatabase(
        path.join(await getDatabasesPath(), 'schedule-courts.db'),
        onCreate: (db, version) async {
      await createTables(db);
    }, version: 1);
  }
}
