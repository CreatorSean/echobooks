import 'package:echobooks/widgets/enroll_button_widget.dart';
import 'package:echobooks/widgets/page_bar_widget.dart';
import 'package:flutter/material.dart';

import '../db/bookDB.dart';
import '../db/bookMemoDB.dart';
import '../models/book_memo_model.dart';
import '../models/book_model.dart';
import '../widgets/book_info_widget.dart';
import '../widgets/book_memo_widget.dart';

class DetailScreen extends StatefulWidget {
  final bool isViewingMemo; //true: MemoList 보임, false: <등록> 버튼 보임
  final BookModel myBook;
  final Function updateHomeScreen;

  const DetailScreen({
    super.key,
    required this.myBook,
    required this.isViewingMemo,
    required this.updateHomeScreen,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<List<BookMemoModel>> myMemos;

  ///<등록>버튼 눌렀을 때, 책정보를 BookDataBase에 저장하는 함수입니다.
  void onEnrollTap() {
    DBHelper().insertBook(widget.myBook);
  }

  Future<List<BookMemoModel>> getMyMemosByTitle() {
    setState(() {
      myMemos = BookMemoDB().getBookMemosByTitle(widget.myBook.title);
    });
    return myMemos;
  }

  void _update() {
    myMemos = getMyMemosByTitle();
    print("detailScreenUpdate");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 5,
        ),
        child: Column(
          children: [
            BookInfoWidget(
              myBook: widget.myBook,
            ),
            const SizedBox(
              height: 10,
            ),
            PageBarWidget(
              myBook: widget.myBook,
            ),
            widget.isViewingMemo
                ? const SizedBox(height: 20)
                : const SizedBox(height: 50),
            widget.isViewingMemo
                ? Expanded(
                    child: BookMemoWidget(
                      myBook: widget.myBook,
                      id: widget.myBook.id,
                      title: widget.myBook.title,
                      detailScreenUpdate: _update,
                    ),
                  )
                : EnrollButtonWidget(
                    onEnrollTap: onEnrollTap,
                    updateHomeScreen: widget.updateHomeScreen,
                    bookModel: widget.myBook,
                  ),
          ],
        ),
      ),
    );
  }
}
