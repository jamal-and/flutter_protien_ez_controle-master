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
          "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
        );
      },
      version: 0,
    );
    final Database db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
      );
      await db.execute('ALTER TABLE single_protein ADD hour');
    }catch(e){
      print('e');
    }
    //
    print(' Hour is ${singleProtein.toMap()}');
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
  static Future<void> updateSingleProtein(SingleProtein singleProtein) async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {

        return db.execute(
          "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
        );
      },
      version: 0,
    );
    final Database db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
      );
      await db.execute('ALTER TABLE single_protein ADD hour');
    }catch(e){
      print('e');
    }
    //
    print(' Hour is ${singleProtein.toMap()}');
    await db.update(
      'single_protein',
      singleProtein.toMap(),
      where: 'hour==?',
      whereArgs: [singleProtein.hour],
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
          "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
        );
      },
      version: 0,
    );
    // Get a reference to the database.
    final db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
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
      print('${maps[i]['hour']}');
      return SingleProtein(
        date: maps[i]['date'],
        number: maps[i]['number'],
        text: maps[i]['text'],
        hour: maps[i]['hour']
      );
    });
  }
  static Future<int> countSingeProteins() async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {

        return db.execute(
          "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
        );
      },
      version: 0,
    );
    // Get a reference to the database.
    final db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
      );
    }catch(e){
      print('e');
    }

    // Query the table for all The Dogs.

    final int sum = Sqflite.firstIntValue(await db.rawQuery('SELECT SUM(number) FROM single_protein'));



    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return sum;
  }
  static deleteSingleProtein(String text,int number,String hour) async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {

        return db.execute(
          "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
        );
      },
      version: 0,
    );
    // Get a reference to the database.
    final db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS single_protein(date TEXT , number INTEGER,  text TEXT DEFAULT '-', hour TEXT)",
      );
    }catch(e){
      print('e');
    }

    // Query the table for all The Dogs.

    await db.delete('single_protein',where: 'text == ? AND number == ? AND hour == ?',whereArgs: [text,number,hour]);


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
      if(pro!=null && pro.protein!=null) {
        return pro;
      }else{
        return Protein(protein: 0,weight: prefs.getInt('weight'),isDone: 0,date: formatted);
      }
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









  static Future<void> addMeal(Meal meal) async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {

        return db.execute(
          "CREATE TABLE IF NOT EXISTS meals(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , protein INTEGER,  description TEXT DEFAULT 'no description', color TEXT)",
        );
      },
      version: 0,
    );
    final Database db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS meals(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , protein INTEGER,  description TEXT DEFAULT 'no description', color TEXT)",
      );
    }catch(e){
      print('e');
    }
    //
    //print(' Hour is ${meal.toMap()}');
    await db.insert(
      'meals',
      meal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }


  static Future<void> updateMeal(Meal meal) async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {

        return db.execute(
          "CREATE TABLE IF NOT EXISTS meals(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , protein INTEGER,  description TEXT DEFAULT 'no description', color TEXT)",
        );
      },
      version: 0,
    );
    final Database db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS meals(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , protein INTEGER,  description TEXT DEFAULT 'no description', color TEXT)",
      );
    }catch(e){
      print('e');
    }
    //
    //print(' Hour is ${meal.toMap()}');
    await db.update(
      'meals',
      meal.toMap(),
      where: 'id==?',
      whereArgs: [meal.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }


  static Future<void> deleteMeal(Meal meal) async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {

        return db.execute(
          "CREATE TABLE IF NOT EXISTS meals(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , protein INTEGER,  description TEXT DEFAULT 'no description', color TEXT)",
        );
      },
      version: 0,
    );
    final Database db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS meals(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , protein INTEGER,  description TEXT DEFAULT 'no description', color TEXT)",
      );
    }catch(e){
      print('e');
    }
    //
    //print(' Hour is ${meal.toMap()}');
    await db.delete(
      'meals',
      where: 'id==?',
      whereArgs: [meal.id],
    );

  }

  static Future<List<Meal>> getMeals() async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'proteins.db'),
      onCreate: (db, version) {

        return db.execute(
          "CREATE TABLE IF NOT EXISTS meals(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , protein INTEGER,  description TEXT DEFAULT 'no description', color TEXT)",
        );
      },
      version: 0,
    );
    final Database db = await database;
    try {
      db.execute(
        "CREATE TABLE IF NOT EXISTS meals(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT , protein INTEGER,  description TEXT DEFAULT 'no description', color TEXT)",
      );
    }catch(e){
      print('e');
    }
    //
    //print(' Hour is ${meal.toMap()}');
    final List<Map<String, dynamic>> maps =await db.query(
      'meals',
    );
    return List.generate(maps.length, (i) {
      return Meal(
          id: maps[i]['id'],
          name: maps[i]['name'],
          protein: maps[i]['protein'],
          description: maps[i]['description'],
          color: maps[i]['color']
      );
    });

  }
}