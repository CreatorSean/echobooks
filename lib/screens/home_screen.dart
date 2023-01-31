import 'package:echobooks/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:echobooks/models/book_model.dart';

import '../db/bookDB.dart';
import '../widgets/book_cover_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final List<String> _valueList = ['읽는 중', '다 읽음'];

  bool isEditButtonClicked = false;
  bool isBookSelected = false;
  bool isDelete = false;
  bool isReading = true;
  late Future<List<BookModel>> myBooks;
  late List<BookCoverWidget> _bookWidgetList;

  @override
  void initState() {
    super.initState();
    myBooks = getMyBooksByReadState();
  }

  void _update() {
    myBooks = getMyBooksByReadState();
    setState(() {
      isReading = true;
    });
  }

  /// 읽음 상태에 따른 책 정보를 불러오는 함수입니다.(예. 읽는중/다읽음)
  Future<List<BookModel>> getMyBooksByReadState() {
    setState(() {
      isReading
          ? myBooks = DBHelper().getBooksByReadingState(0)
          : myBooks = DBHelper().getBooksByReadingState(1);
    });
    return myBooks;
  }

  void setEditScreen() {
    setState(() {
      isEditButtonClicked = true;
    });
  }

  void setMyBookScreen() {
    deleteSelectedBooks();
    getMyBooksByReadState();
    setState(() {
      isEditButtonClicked = false;
    });
  }

  void deleteSelectedBooks() async {
    for (BookCoverWidget book in _bookWidgetList) {
      if (book.isBookSelected) {
        await DBHelper().deleteBook(book.myBook.id);
      }
    }
  }

  List<Widget> makeBookWidgetList(AsyncSnapshot snapshot) {
    _bookWidgetList = List<BookCoverWidget>.generate(
      snapshot.data!.length,
      (index) {
        return BookCoverWidget(
          myBook: snapshot.data![index],
          isBookSelected: isBookSelected,
          isEditButtonClicked: isEditButtonClicked,
          isDelete: isDelete,
          updateParent: _update,
          detectDeleteButton: setMyBookScreen,
        );
      },
    );

    return _bookWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ECHO BOOKS',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1!.color,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              //==========================검색바(버튼 기능)==================================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(
                        updateHomeScreen: _update,
                      ),
                    ),
                  );
                },
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 340,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.search_rounded),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //====================책 보여주는 하얀 컨테이너 부분===========================
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 340,
                height: 650,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //===================<읽는중>, <편집> 버튼==============================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        isEditButtonClicked
                            ? TextButton(
                                onPressed: () {
                                  setMyBookScreen();
                                  isBookSelected = false;
                                },
                                child: const Text(
                                  '취소',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : DropdownButton(
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                value:
                                    isReading ? _valueList[0] : _valueList[1],
                                items: _valueList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newvalue) {
                                  setState(() {
                                    isReading = !isReading;
                                  });
                                },
                              ),
                        isEditButtonClicked
                            ? TextButton(
                                onPressed: () {
                                  setMyBookScreen();
                                },
                                child: const Text(
                                  '삭제',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  setEditScreen();
                                },
                                child: Text(
                                  '편집',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .color,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    //=====================북커버위젯(GridView)=============================
                    Expanded(
                      child: FutureBuilder(
                        future: getMyBooksByReadState(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    2 / 3.2, //item 의 가로 1, 세로 2 의 비율
                                mainAxisSpacing: 15, //수평 Padding
                                crossAxisSpacing: 10, //수직 Padding
                                children: makeBookWidgetList(snapshot),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
