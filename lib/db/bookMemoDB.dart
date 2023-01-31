import 'package:echobooks/models/book_memo_model.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

const String bookMemoTable = "bookMemoTable";
const String createTableSql = "CREATE TABLE $bookMemoTable (myKey INTEGER PRIMARY KEY, id TEXT, title TEXT, phrase TEXT, memo TEXT, date TEXT);";

class BookMemoDB {
  initDb() async {
    String path = join(await getDatabasesPath(), 'BookMemos.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(createTableSql);
      },
      version: 1,
    );
  }

  Future<List<BookMemoModel>> getAllBookMemos() async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.query(bookMemoTable);

    return List.generate(maps.length, (i) {
      return BookMemoModel(
        myKey: maps[i]['myKey'],
        id: maps[i]['id'],
        title: maps[i]['title'],
        phrase: maps[i]['phrase'],
        memo: maps[i]['memo'],
        date: maps[i]['date'],
      );
    });
  }

  Future<List<BookMemoModel>> getBookMemosByTitle(String title) async {
    final db = await initDb();

    final List<Map<String, dynamic>> maps = await db.query(
      bookMemoTable,
      where: 'title=?',
      whereArgs: [
        title
      ],
    );

    return List.generate(maps.length, (i) {
      return BookMemoModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        myKey: maps[i]['myKey'],
        phrase: maps[i]['phrase'],
        memo: maps[i]['memo'],
        date: maps[i]['date'],
      );
    });
  }

  Future insertBookMemo(BookMemoModel bookMemoModel) async {
    final db = await initDb();
    await db.insert(bookMemoTable, bookMemoModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future updateBookMemo(BookMemoModel bookMemoModel) async {
    final db = await initDb();
    await db.update(bookMemoTable, bookMemoModel.toMap(), where: 'myKey = ?', whereArgs: [
      bookMemoModel.myKey
    ]);
  }

  Future rawUpdateBookMemo(String phrase, String memo, int myKey) async {
    final db = await initDb();
    await db.update('UPDATE $bookMemoTable SET phrase = $phrase, memo = $memo WHERE myKey = $myKey');
  }

  Future deleteBookMemo(int myKey) async {
    final db = await initDb();
    await db.delete(bookMemoTable, where: 'myKey = ?', whereArgs: [
      myKey
    ]);
  }
}
