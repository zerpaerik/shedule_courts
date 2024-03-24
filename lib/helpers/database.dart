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
        isActive INTEGER,
        dateSchedule TEXT
        )""");
  }

  static Future<Database> openDB() async {
    return openDatabase(
        path.join(await getDatabasesPath(), 'schedule-courts.db'),
        onCreate: (db, version) async {
      await createTables(db);
    }, version: 1);
  }

  // Read all schedule
  static Future<List<Map<String, dynamic>>> getScheduleAll() async {
    Database database = await openDB();
    final List<Map<String, dynamic>> data =
        await database.query('schedule', orderBy: "dateSchedule DESC");
    return data;
  }

  static Future<int> insertSchedule(Schedule schedule) async {
    Database database = await openDB();
    Map<String, dynamic> row = {
      "court": schedule.court,
      "dateSchedule": schedule.dateSchedule,
      "userSchedule": schedule.userSchedule,
      "isActive": schedule.isActive,
    };
    return database.insert("schedule", row);
  }

  static Future<int> query(data) async {
    // get a reference to the database
    Database database = await openDB();

    String whereString = 'court = ? AND dateSchedule = ?';
    List<dynamic> whereArguments = [data['court'], data['dateSchedule']];
    List<Map> result = await database.query("schedule",
        // columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    return result.length;
    // {_id: 1, name: Bob, age: 23}
  }

  static Future<void> deleteSchedule(int id) async {
    Database database = await openDB();
    try {
      await database.delete("schedule", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      //("Something went wrong when deleting an item: $err");
    }
  }
}
