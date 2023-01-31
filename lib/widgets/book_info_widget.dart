import 'package:echobooks/models/book_model.dart';
import 'package:flutter/material.dart';

class BookInfoWidget extends StatelessWidget {
  final BookModel myBook;
  const BookInfoWidget({
    super.key,
    required this.myBook,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //====================Book Image 보여주는 부분=============================
          Container(
            height: 130,
            width: 90,
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
            child: myBook.image == "icon"
                ? const Icon(
                    Icons.menu_book_rounded,
                    size: 50,
                  )
                : Image.network(myBook.image),
          ),
          const SizedBox(
            width: 25,
          ),
          //===========Book Title, Author, Info 보여주는 부분=============================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //============Title=================
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      myBook.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //=============Author===============
                  Text(
                    myBook.author,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //==============Info================
                  SizedBox(
                    height: 80,
                    width: 230,
                    child: Text(
                      myBook.info,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
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
