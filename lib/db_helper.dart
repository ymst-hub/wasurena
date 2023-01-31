import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wasurena/person_detail_model.dart';
import 'package:wasurena/person_model.dart';

// Personテーブルのカラム名を設定
const String PcolumnId = '_id';
const String PcolumnDegree = 'degree';
const String PcolumnName = 'name';
const String PcolumnIcon = 'icon';

// PersonDetailテーブルのカラム名を設定
const String DcolumnSerial = '_serial';
const String DcolumnId = '_id';
const String DcolumnFlag = 'flag';
const String DcolumnDetail = 'detail';

// Personテーブルのカラム名をListに設定
const List<String> Pcolumns = [
  PcolumnId,
  PcolumnDegree,
  PcolumnName,
  PcolumnIcon,
];

// PersonDetailテーブルのカラム名をListに設定
const List<String> Dcolumns = [
  DcolumnSerial,
  DcolumnId,
  DcolumnFlag,
  DcolumnDetail,
];


// Person、PersonDetailテーブルへのアクセスをまとめたクラス
class DbHelper {
  // DbHelperをinstance化する
  static final DbHelper instance = DbHelper._createInstance();
  static Database? _database;

  DbHelper._createInstance();

  // databaseをオープンしてインスタンス化する
  Future<Database> get database async {
    return _database ??= await _initDB();       // 初回だったら_initDB()=DBオープンする
  }

  // データベースをオープンする
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'wasurena.db');    // wasurena.dbのパスを取得する

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,      // Person.dbがなかった時の処理を指定する（DBは勝手に作られる）
    );
  }

  // データベースがなかった時の処理
  Future _onCreate(Database database, int version) async {
    //Personテーブルをcreateする
    await database.execute('''
      CREATE TABLE Person(
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        degree TEXT,
        name TEXT,
        icon TEXT
      )
    ''');

    //PersonDetailテーブルを作成する
    await database.execute('''
      CREATE TABLE PersonDetail(
        _serial INTEGER PRIMARY KEY AUTOINCREMENT,
        _id INTEGER ,
        flag INTEGER,
        detail TEXT
      )
    ''');
  }

  /*
  * Personテーブル関連
  * ※deleteのみPersonDetailテーブルからも削除
  * */

  // Personテーブルのデータを全件取得する
  Future<List<Person>> selectAllPerson() async {
    final db = await instance.database;
    final personData = await db.query(
      'Person',
      orderBy: PcolumnDegree,//距離に応じてリストの下に追加する
    );

    return personData.map((json) => Person.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
  }

  // _idをキーにして1件のデータを読み込む
  Future<Person> PersonData(int id) async {
    final db = await instance.database;
    var person = [];
    person = await db.query(
      'Person',
      columns: Pcolumns,
      where: '_id = ?',                     // 渡されたidをキーにしてPersonテーブルを読み込む
      whereArgs: [id],
    );
    return Person.fromJson(person.first);      // 1件だけなので.toListは不要
  }

// データをinsertする
  Future Personinsert(Person person) async {
    final db = await database;
    return await db.insert(
        'Person',
        person.toJson()                         // Person_model.dartで定義しているtoJson()で渡されたPersonをパースして書き込む
    );
  }


// データをupdateする
  Future Personupdate(Person person) async {
    final db = await database;
    return await db.update(
      'Person',
      person.toJson(),
      where: '_id = ?',                   // idで指定されたデータを更新する
      whereArgs: [person.id],
    );
  }

// データを削除する
  Future Persondelete(int id) async {
    final db = await instance.database;
    await db.delete(
      'Person',
      where: '_id = ?',                   // idで指定されたデータを削除する
      whereArgs: [id],
    );
    //persondetailテーブルも同時に削除する
    await db.delete(
      'PersonDetail',
      where: '_id = ?',                   // idで指定されたデータを削除する
      whereArgs: [id],
    );
    return db;
  }


  /*
   * PersonDetailテーブル
   */

  // _idをキーにしてPersonDetailのデータを読み込む
  Future<List<PersonDetail>> PersonDetailData(int id) async {
    final db = await instance.database;
    final personDetailData = await db.query(
      'PersonDetail',
      columns: Pcolumns,
      where: '_id = ?',                     // 渡されたidをキーにしてPersonテーブルを読み込む
      whereArgs: [id],
    );
    return personDetailData.map((json) => PersonDetail.fromJson(json)).toList();
  }

// データをinsertする
  Future Detailinsert(PersonDetail personDetail) async {
    final db = await database;
    return await db.insert(
        'PersonDetail',
        personDetail.toJson()                         // Person_model.dartで定義しているtoJson()で渡されたPersonをパースして書き込む
    );
  }

// データを削除する
  Future Detaildelete(int serial,int id) async {
    final db = await instance.database;
    await db.delete(
      'PersonDetail',
      where: '_serial = ? AND _id = ?',                   // idで指定されたデータを削除する
      whereArgs: [serial,id],
    );
    return db;
  }




}