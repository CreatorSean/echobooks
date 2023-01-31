import 'package:echobooks/models/book_model.dart';
import 'package:echobooks/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class BookListWidget extends StatefulWidget {
  final String title, id, image, author, info;
  final Function updateHomeScreen;

  const BookListWidget({
    super.key,
    required this.title,
    required this.image,
    required this.author,
    required this.id,
    required this.info,
    required this.updateHomeScreen,
  });

  @override
  State<BookListWidget> createState() => _BookListWidgetState();
}

class _BookListWidgetState extends State<BookListWidget> {
  late BookModel searchBook;

  @override
  void initState() {
    super.initState();
    searchBook = BookModel(
        id: widget.id,
        title: widget.title,
        image: widget.image,
        author: widget.author,
        info: widget.info,
        totalPage: 1000,
        currentPage: 0,
        readDone: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              myBook: searchBook,
              isViewingMemo: false, //memo가 아닌 <등록> 버튼 보이게 함
              updateHomeScreen: widget.updateHomeScreen,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //====================Book Image 보여주는 부분=============================
          Container(
            height: 115,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]),
            child: widget.image == "icon"
                ? const Icon(
                    Icons.menu_book_rounded,
                    size: 50,
                  )
                : Image.network(widget.image),
          ),
          const SizedBox(
            width: 25,
          ),
          //===============Book Title, Author 보여주는 부분=============================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.author,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
