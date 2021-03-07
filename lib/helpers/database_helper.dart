
import 'package:news_hacker_app/models/local_data_model.dart';
import 'package:news_hacker_app/models/stories_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper _databaseHelper = DatabaseHelper.internal();

  factory DatabaseHelper() => _databaseHelper;

  DatabaseHelper.internal();

  String savedTable = 'saved_table';
  String id = 'idColumn';
  String title = 'titleColumn';
  String by = 'byColumn';

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "news1.db");

    return await openDatabase(path, version: 1,onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $savedTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $by TEXT, $title TEXT)"
      );
    });
  }

  Future<LocalData> saveNew(LocalData localData) async {
    Database savedDb = await db;
    localData.id = await savedDb.insert(savedTable, localData.toMap());
    return localData;
  }

  Future<List> getAllSavedNews() async {
    Database savedDb = await db;
    List listMap = await savedDb.rawQuery("SELECT * FROM $savedTable");
    List<LocalData> savedList =[];
    for(Map m in listMap){
      savedList.add(LocalData.fromMap(m));
    }
    return savedList;
  }
}