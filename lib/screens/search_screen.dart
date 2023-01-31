import 'package:echobooks/services/api_service.dart';
import 'package:echobooks/widgets/book_list_widget.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';

class SearchScreen extends StatefulWidget {
  final Function updateHomeScreen;
  const SearchScreen({
    super.key,
    required this.updateHomeScreen,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isQuery = false;
  Future<List<BookModel>>? books;

  ///사용자에게 입력받은 쿼리로 책 API를 불러오는 함수입니다.
  void getBookApiByQuery(String userQuery) {
    String query = userQuery;
    isQuery = true;
    setState(() {
      books = ApiService.getSearchBooksByQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    final FocusNode focusNode = FocusNode();

    return GestureDetector(
      ///검색 화면에서 다른 곳 누르면 키보드 내려가는 함수
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      }, //여기까지
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          title: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30),
            ),
            width: 340,
            height: 40,
            child: Center(
              child: TextField(
                controller: textController,
                focusNode: focusNode,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) => getBookApiByQuery(textController.text),
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => getBookApiByQuery(textController.text),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {},
                  ),
                  hintText: '책을 검색하세요',
                  border: InputBorder.none,
                ),
              ),
            ),
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
        body: FutureBuilder(
          future: books,
          builder: (context, snapshot) {
            if (isQuery) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: makeSearchBookList(
                        snapshot,
                        widget.updateHomeScreen,
                      )),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

ListView makeSearchBookList(
    AsyncSnapshot<List<BookModel>> snapshot, updateHomeScreen) {
  return ListView.separated(
    scrollDirection: Axis.vertical,
    itemCount: snapshot.data!.length,

    padding: const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 20,
    ),

    //itemBuilder: ListView의 item을 만드는 역할을 함. 필요한 만큼만 로드하여 최적화함.
    itemBuilder: (context, index) {
      var book = snapshot.data![index];

      return BookListWidget(
        title: book.title,
        author: book.author,
        image: book.image,
        id: book.id,
        info: book.info,
        updateHomeScreen: updateHomeScreen,
      );
    },

    //separatorBuilder: ListView의 item 사이의 간격을 줌.
    separatorBuilder: (context, index) => const SizedBox(
      height: 40,
    ),
  );
}
