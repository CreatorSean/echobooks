import 'package:echobooks/models/book_memo_model.dart';
import 'package:echobooks/widgets/book_my_memo_widget.dart';
import 'package:flutter/material.dart';

import '../db/bookMemoDB.dart';
import '../models/book_model.dart';
import '../screens/memo_screen.dart';

class BookMemoWidget extends StatefulWidget {
  String id, title;
  BookModel myBook;
  final Function detailScreenUpdate;

  BookMemoWidget({
    required this.myBook,
    required this.id,
    required this.title,
    required this.detailScreenUpdate,
    Key? key,
  }) : super(key: key);

  @override
  State<BookMemoWidget> createState() => _BookMemoWidgetState();
}

class _BookMemoWidgetState extends State<BookMemoWidget> {
  // late Future<List<BookMemoModel>> myBookMemos;

  // BookMemoDB memoDB = BookMemoDB();

  Future<List<BookMemoModel>> getAllBookMemoDB() {
    return BookMemoDB().getAllBookMemos();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getAllBookMemoDB();
  //   setState(() {});
  // }

  // late Future<List<BookMemoModel>> myMemos;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      child: Column(
        children: [
          Text(
            "감상평",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline1!.color,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 340,
            height: 240,
            child: FutureBuilder(
              future: getAllBookMemoDB(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(width: 340, height: 300, child: makeBookMemoList(snapshot));
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoScreen(
                    isMemoEdit: false,
                    myBook: widget.myBook,
                    id: widget.id,
                    title: widget.title,
                    detailScreenUpdate: widget.detailScreenUpdate,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add_circle_outline_rounded,
            ),
            color: Theme.of(context).textTheme.headline1!.color,
            iconSize: 35,
          ),
        ],
      ),
    );
  }

  ListView makeBookMemoList(AsyncSnapshot<List<BookMemoModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,

      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),

      //itemBuilder: ListView의 item을 만드는 역할을 함. 필요한 만큼만 로드하여 최적화함.
      itemBuilder: (context, index) {
        var memo = snapshot.data![index];

        return BookMyMemoWidget(
          myBook: widget.myBook,
          myBookMemo: memo,
          detailScreenUpdate: widget.detailScreenUpdate,
        );
      },

      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
    );
  }
}
