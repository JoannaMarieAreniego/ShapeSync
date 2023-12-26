//db_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  //constants
  static const dbName = 'tracker.db';
  static const dbversion = 8;

  //table constants
  //height table
  static const tbHeight = 'height';
  static const colHeightId = 'heightid';
  static const colHeightDate = 'hdate';
  static const colHeightValue = 'heightValue';

  //weight table
  static const tbWeight = 'weight';
  static const colWeightId = 'weightid';
  static const colWeightDate = 'wdate';
  static const colWeightValue = 'weightValue';
  static const colWHeightIdFK = 'wheightId'; // Foreign Key referencing tbHeight

  //bmi table
  static const tbBMI = 'bmi';
  static const colBMIId = 'bmiid';
  static const colBMIDate = 'bmidate';
  static const colBMIValue = 'bmiValue';
  static const colBMICategory = 'category';
  static const colBMIHeightId = 'bmiheightId'; // Foreign Key referencing tbHeight
  static const colBMIWeightId = 'bmiweightId'; // Foreign Key referencing tbWeight

  //openDB
  static Future<Database> openDB()async{
    var path =join( await getDatabasesPath() , DbHelper.dbName);
    print('Database Path: $path');
    //Create height table
    var sql1 = "CREATE TABLE IF NOT EXISTS $tbHeight ($colHeightId INTEGER PRIMARY KEY AUTOINCREMENT, $colHeightValue DECIMAL(4, 4), $colHeightDate TEXT)";
    // Create Weight table
    var sql2 = "CREATE TABLE IF NOT EXISTS $tbWeight ($colWeightId INTEGER PRIMARY KEY AUTOINCREMENT, $colWeightValue DECIMAL(4, 4), $colWeightDate TEXT, $colWHeightIdFK INTEGER, FOREIGN KEY ($colWHeightIdFK) REFERENCES $tbHeight($colHeightId) ON DELETE CASCADE)";
    // Create BMI table
    var sql3 = '''
      CREATE TABLE IF NOT EXISTS $tbBMI (
        $colBMIId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colBMIValue NUMERIC,
        $colBMICategory TEXT,
        $colBMIDate TEXT,
        $colBMIHeightId INTEGER,
        $colBMIWeightId INTEGER,
        FOREIGN KEY ($colBMIHeightId) REFERENCES $tbHeight($colHeightId) ON DELETE CASCADE,
        FOREIGN KEY ($colBMIWeightId) REFERENCES $tbWeight($colWeightId) ON DELETE CASCADE
      )
    ''';
    var db = await openDatabase(
      path,
      version: DbHelper.dbversion,
      onCreate: (db, version) {
        //Execute height table
        db.execute(sql1);
        print('Height table created');
        // Execute Weight table
        db.execute(sql2);
        print('Weight table created');
        // Execute BMI table
        db.execute(sql3);
        print('BMI table created');
      },
      onUpgrade: (db, oldVersion, newVersion){
        if(newVersion <= oldVersion)
        return;
        db.execute('DROP TABLE IF EXISTS $tbBMI');
        db.execute('DROP TABLE IF EXISTS $tbHeight');
        db.execute('DROP TABLE IF EXISTS $tbWeight');
        db.execute(sql1);
        print('Weight table recreated');
        db.execute(sql2);
        print('Height table recreated');
        db.execute(sql3);
        print('BMI table recreated');
        print('dropped and recreated');
      },
    );
    return db;
  }

  static Future<List<Map<String, dynamic>>> getDataPreview() async {
    final db = await openDB();
    return db.rawQuery('''
      SELECT
        $tbBMI.$colBMIId,
        $tbBMI.$colBMIValue,
        $tbBMI.$colBMICategory,
        $tbBMI.$colBMIDate,
        $tbHeight.$colHeightValue,
        $tbWeight.$colWeightValue
      FROM $tbBMI
      LEFT JOIN $tbHeight ON $tbBMI.$colBMIHeightId = $tbHeight.$colHeightId
      LEFT JOIN $tbWeight ON $tbBMI.$colBMIWeightId = $tbWeight.$colWeightId
    ''');
  }

  //INSERTION
  static Future<void> insertData(double height, double weight, double bmi, String category) async {
    final db = await openDB();
    await db.insert(
      tbBMI,
      {
        colBMIValue: bmi,
        colBMICategory: category,
        colBMIHeightId: await _insertHeight(height),
        colBMIWeightId: await _insertWeight(weight),
        colBMIDate: DateTime.now().toIso8601String(),
      },
    );
  }

  //HEIGHT INSERT
  static Future<int> _insertHeight(double height) async {
  final db = await openDB();
  return await db.insert(
    tbHeight,
    {
      colHeightValue: height,
      colHeightDate: DateTime.now().toIso8601String(),
    },
  );
}
  //WEIGHT INSERT
  static Future<int> _insertWeight(double weight) async {
    final db = await openDB();
    return await db.insert(
      tbWeight,
      {
        colWeightValue: weight,
        colWeightDate: DateTime.now().toIso8601String(),
      },
    );
  }

  //DELETION
  static Future<void> deleteData(int id) async {
    var db = await openDB();
    await db.delete(tbHeight, where: '$colHeightId = ?', whereArgs: [id]);
    await db.delete(tbWeight, where: '$colWeightId = ?', whereArgs: [id]);
    await db.delete(tbBMI, where: '$colBMIId = ?', whereArgs: [id]);
  }

  //UPDATE
  static Future<void> updateData(int id, double height, double weight, double bmi, String date) async {
    final db = await openDB();
    double newBmi = calculateBMI(height, weight);

    await db.update(
      tbBMI,
      {
        colBMIValue: newBmi,
        colBMIHeightId: await _insertHeight(height),
        colBMIWeightId: await _insertWeight(weight),
        colBMIDate: date,
      },
      where: '$colBMIId = ?',
      whereArgs: [id],
    );
  }

  //RE-CALCULATION OF BMI IN UPDATE
  static double calculateBMI(double height, double weight) {
  if (height > 0) {
    return weight / ((height / 100) * (height / 100));
  }
  return 0;
}

static Future<bool> hasData() async {
  final db = await openDB();
  final result = await db.rawQuery('SELECT COUNT(*) as count FROM $tbBMI');
  final count = Sqflite.firstIntValue(result);

  return count != null && count > 0;
}

}