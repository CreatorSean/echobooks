import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/bookMemoDB.dart';
import '../models/book_memo_model.dart';
import 'dart:math';

import '../models/book_model.dart';

class MemoScreen extends StatefulWidget {
  // BookMemoModel myBookMemo;
  String id, title;
  BookModel myBook;
  final Function detailScreenUpdate;
  //수정
  bool isMemoEdit;

  MemoScreen({
    super.key,
    required this.myBook,
    required this.id,
    required this.title,
    required this.detailScreenUpdate,
    required this.isMemoEdit,
    // required this.myBookMemo,
  });

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  late String phrase, memo;

  Future<List<BookMemoModel>> getMemos() {
    setState(() {});
    return BookMemoDB().getBookMemosByTitle(widget.title);
  }

  final TextEditingController textControllerForPharse = TextEditingController();
  final TextEditingController textControllerForMemo = TextEditingController();

  List<BookMemoModel> myBookMemos = [];

  BookMemoDB bookMemosDb = BookMemoDB();

  void insertBookMemo() async {
    await bookMemosDb.insertBookMemo(
      BookMemoModel(
        myKey: Random().nextInt(100000),
        id: widget.id,
        title: widget.title,
        phrase: phrase,
        memo: memo,
        date: DateFormat('yyyy-MM-dd').format(
          DateTime.now(),
        ),
      ),
    );
    widget.detailScreenUpdate();
  }

  void updateBookMemo() async {
    await bookMemosDb.updateBookMemo(
      BookMemoModel(
        myKey: Random().nextInt(100000),
        id: widget.id,
        title: widget.title,
        phrase: phrase,
        memo: memo,
        date: DateFormat('yyyy-MM-dd').format(
          DateTime.now(),
        ),
      ),
    );
    widget.detailScreenUpdate();
    print(await BookMemoDB().getAllBookMemos());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.isMemoEdit ? updateBookMemo() : insertBookMemo();
                    //widget.detailScreenUpdate();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "저장",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline2!.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            foregroundColor: Theme.of(context).textTheme.headline2!.color,
          ),
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textControllerForPharse,
                  decoration: const InputDecoration(contentPadding: EdgeInsets.all(10), hintText: "\"책의 문구를 적어보세요\""),
                  style: const TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                  onChanged: (value) {
                    setState(
                      () {
                        phrase = textControllerForPharse.text;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: textControllerForMemo,
                  cursorColor: Theme.of(context).textTheme.headline1!.color,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    hintText: "책을 통해 느낀 감정을 적어주세요",
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 10,
                  onChanged: (value) {
                    setState(
                      () {
                        memo = textControllerForMemo.text;
                      },
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }
}
