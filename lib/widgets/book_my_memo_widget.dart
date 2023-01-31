import 'package:echobooks/db/bookMemoDB.dart';
import 'package:echobooks/models/book_memo_model.dart';
import 'package:echobooks/screens/memo_screen.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';

class BookMyMemoWidget extends StatefulWidget {
  late BookMemoModel myBookMemo;
  BookModel myBook;
  final Function detailScreenUpdate;

  BookMyMemoWidget({
    required this.myBookMemo,
    required this.myBook,
    required this.detailScreenUpdate,
    super.key,
  });

  @override
  State<BookMyMemoWidget> createState() => _BookMyMemoWidgetState();
}

class _BookMyMemoWidgetState extends State<BookMyMemoWidget> {
  void deleteMemo() {
    BookMemoDB().deleteBookMemo(widget.myBookMemo.myKey);
  }

  void awaitBookMemoState(context, BookModel myBook) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MemoScreen(
          id: myBook.id,
          title: myBook.title,
          myBook: myBook,
          detailScreenUpdate: widget.detailScreenUpdate,
          isMemoEdit: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        awaitBookMemoState(context, widget.myBook);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 240,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 240,
                        height: 25,
                        child: Text(
                          widget.myBookMemo.phrase,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 240,
                    height: 25,
                    child: Text(
                      widget.myBookMemo.memo,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 35,
              height: 60,
              child: IconButton(
                onPressed: () {
                  deleteMemo();
                  widget.detailScreenUpdate();
                },
                icon: const Icon(
                  Icons.delete_outline,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
