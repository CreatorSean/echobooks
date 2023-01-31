import 'dart:async';

import 'package:echobooks/models/book_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String bookTable = "booksTable";
const String createTableSql =
    "CREATE TABLE $bookTable(id TEXT PRIMARY KEY, title TEXT, image TEXT, author TEXT, info TEXT, totalPage INTEGER, currentPage INTEGER, readDone INTEGER);";

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await initDB();
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'books.db');
    final Future<Database> database = openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(createTableSql);
      },
      version: 1,
    );
    return database;
  }

  ///DB에 insert하는 함수입니다.
  void insertBook(BookModel books) async {
    final db = await initDB();
    db.insert(
      bookTable,
      books.toMap(),
      // 동일한 book이 두번 추가되는 경우 방지
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BookModel>> getAllBooks() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(bookTable);

    return List.generate(maps.length, (i) {
      return BookModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        image: maps[i]['image'],
        info: maps[i]['info'],
        totalPage: maps[i]['totalPage'],
        currentPage: maps[i]['currentPage'],
        readDone: maps[i]['readDone'],
      );
    });
  }

  ///ReadDone 상태에 따른 책들을 DB에서 불러오는 함수입니다.
  Future<List<BookModel>> getBooksByReadingState(int readDone) async {
    final db = await initDB();

    final List<Map<String, dynamic>> maps = await db.query(
      bookTable,
      where: 'readDone=?',
      whereArgs: [readDone],
    );

    return List.generate(maps.length, (i) {
      return BookModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        image: maps[i]['image'],
        info: maps[i]['info'],
        totalPage: maps[i]['totalPage'],
        currentPage: maps[i]['currentPage'],
        readDone: maps[i]['readDone'],
      );
    });
  }

  updateBook(BookModel bookModel) async {
    final db = await initDB();

    await db.update(
      bookTable,
      bookModel.toMap(),
      where: "id = ?",
      whereArgs: [bookModel.id],
    );
  }

  deleteBook(String id) async {
    final db = await initDB();
    await db.delete(
      bookTable,
      where: "id=?",
      whereArgs: [id],
    );
  }
}
