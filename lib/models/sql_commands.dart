import 'package:shared_preferences/shared_preferences.dart';
import 'data_for_sql.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
class MakeCommand{

  // Define a function that inserts dogs into the database
  static Future<void> insertProtein(Protein protein) async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE protein(date TEXT PRIMARY KEY, weight INTEGER, protein INTEGER, done INTEGER DEFAULT 0)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 0,
    );
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'protein',
      protein.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<void> addSingleProtein(SingleProtein singleProtein) async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {

        return db.execute(
          "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-')",
        );
      },
      version: 0,
    );
    final Database db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-')",
      );
    }catch(e){
      print('e');
    }

    await db.insert(
      'single_protein',
      singleProtein.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    DateTime dateTime=DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTime);
    await db.delete(
        'single_protein',
        where: 'date < ?',
        whereArgs: [formatted]
    );
  }
  static Future<List<SingleProtein>> singleProteins() async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {

        return db.execute(
          "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-')",
        );
      },
      version: 0,
    );
    // Get a reference to the database.
    final db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-')",
      );
    }catch(e){
      print('e');
    }

    // Query the table for all The Dogs.
    DateTime dateTime=DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTime);
    final List<Map<String, dynamic>> maps = await db.query('single_protein',where: 'date == ?',whereArgs: [formatted]);



    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return SingleProtein(
        date: maps[i]['date'],
        number: maps[i]['number'],
        text: maps[i]['text'],
      );
    });
  }

  static Future<void> deleteProteins(DateTime dateTime) async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE protein(date TEXT PRIMARY KEY, weight INTEGER, protein INTEGER, done INTEGER DEFAULT 0)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 0,
    );
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTime);
    await db.delete(
      'protein',
      where: 'date < ?',
      whereArgs: [formatted],
    );
    print('deleting done');
  }

  static Future<Protein> proteins(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final DateTime dateTime=DateTime.parse(now);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE protein(date TEXT PRIMARY KEY, weight INTEGER, protein INTEGER, done INTEGER DEFAULT 0)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    try {
      final List<Map<String, dynamic>> maps = await db.query(
          'protein', where: 'date = ?', whereArgs: [formatted]);
      Protein pro = Protein(
          date: maps[0]['date'],
          weight: maps[0]['weight'],
          protein: maps[0]['protein'],
          isDone: maps[0]['done']
      );
      return pro;
    }catch(e){
      print(e);
      return Protein(protein: 0,weight: prefs.getInt('weight'),isDone: 0,date: formatted);
    }
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    //return pro;
    // return List.generate(maps.length, (i) {
    //   return Protein(
    //     date: maps[i]['date'],
    //     weight: maps[i]['weight'],
    //     protein: maps[i]['protein'],
    //     isDone: maps[i]['done']
    //   );
    // });
  }
}