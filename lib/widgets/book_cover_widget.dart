import 'package:flutter/material.dart';
import 'package:echobooks/screens/detail_screen.dart';

import '../models/book_model.dart';

// ignore: must_be_immutable
class BookCoverWidget extends StatefulWidget {
  late bool isEditButtonClicked, isBookSelected, isDelete;
  BookModel myBook;
  final Function updateParent;
  final Function detectDeleteButton;

  BookCoverWidget({
    super.key,
    required this.myBook,
    required this.isBookSelected,
    required this.isEditButtonClicked,
    required this.isDelete,
    required this.updateParent,
    required this.detectDeleteButton,
  });

  @override
  State<BookCoverWidget> createState() => _BookCoverWidgetState();
}

class _BookCoverWidgetState extends State<BookCoverWidget> {
  void awaitBookState(context, BookModel myBook) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => DetailScreen(
          updateHomeScreen: widget.updateParent,
          myBook: myBook,
          isViewingMemo: true,
        ),
      ),
    );
    widget.updateParent();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        awaitBookState(context, widget.myBook);
      },
      child: Column(
        children: [
          widget.isEditButtonClicked
              ? Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: 112,
                    height: 162.4,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.myBook.image),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            myRadioButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: 112,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    child: Image.network(widget.myBook.image),
                  ),
                ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.myBook.title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Stack myRadioButton() {
    return widget.isBookSelected
        ? Stack(children: [
            IconButton(
              onPressed: () {
                setState(
                  () {
                    widget.isBookSelected = false;
                  },
                );
              },
              icon: const Icon(
                Icons.circle,
                size: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(
                  () {
                    widget.isBookSelected = false;
                  },
                );
              },
              icon: Icon(
                Icons.radio_button_checked,
                size: 30,
                color: Colors.blue.shade200,
              ),
            )
          ])
        : Stack(children: [
            IconButton(
              onPressed: () {
                setState(
                  () {
                    widget.isBookSelected = true;
                  },
                );
              },
              icon: const Icon(
                Icons.circle,
                size: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(
                  () {
                    widget.isBookSelected = true;
                  },
                );
              },
              icon: Icon(
                Icons.radio_button_off,
                size: 30,
                color: Colors.blue.shade200,
              ),
            )
          ]);
  }
}
