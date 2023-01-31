import 'package:echobooks/db/bookDB.dart';
import 'package:echobooks/models/book_model.dart';
import 'package:flutter/material.dart';

class PageBarWidget extends StatefulWidget {
  BookModel myBook;
  PageBarWidget({
    super.key,
    required this.myBook,
  });

  @override
  State<PageBarWidget> createState() => _PageBarWidgetState();
}

class _PageBarWidgetState extends State<PageBarWidget> {
  late int myCurrentPage = widget.myBook.currentPage;

  ///슬라이더를 통해 들어온 페이지를 widget.currentPage에 넣어주는 함수(onChanged)
  void updatePage(double newPage) {
    setState(() {
      widget.myBook.currentPage = newPage.toInt();
      myCurrentPage = widget.myBook.currentPage;
    });
  }

  void setReadDoneState(int readDoneValue) async {
    await DBHelper().updateBook(BookModel(
      id: widget.myBook.id,
      title: widget.myBook.title,
      author: widget.myBook.author,
      info: widget.myBook.info,
      image: widget.myBook.image,
      totalPage: widget.myBook.totalPage,
      currentPage: myCurrentPage,
      readDone: readDoneValue,
    ));
  }

  ///슬라이더를 움직이다가 슬라이더를 놓았을 때 실행(onChangedEnd)
  void savePage(double newPage) async {
    if (myCurrentPage == widget.myBook.totalPage) {
      setReadDoneState(1);
    } else {
      setReadDoneState(0);
    }

    setState(() {});
  }

  bool isMyPageZero() {
    return (myCurrentPage == 0);
  }

  //페이지를 나타내는 부분과 슬라이더가 묶여져있는 컬럼입니다 적절한 위치에 그대로 넣어서 사용하면 될 것 같습니다.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //currentPage와 totalPage를 나타내는 text가 있는 row입니다.
                    Text(
                      '${myCurrentPage}p',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isMyPageZero()
                            ? const Color.fromARGB(255, 76, 75, 73)
                            : Theme.of(context).textTheme.headline1!.color,
                      ),
                    ),
                    Text(
                      '${widget.myBook.totalPage}p',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isMyPageZero()
                            ? const Color.fromARGB(255, 76, 75, 73)
                            : Theme.of(context).textTheme.headline1!.color,
                      ),
                    ),
                  ],
                ),
              ),
              //슬라이더가 위치한 곳입니다.
              SliderTheme(
                data: SliderThemeData(
                  //슬라이더 원(thumb)를 눌렀을 때 현재 value를 나타내는 박스 안의 텍스트를 꾸미는 함수
                  valueIndicatorTextStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                  //thumb를 눌렀을 때 현재 value 노출의 여부를 판단하는 함수
                  showValueIndicator: ShowValueIndicator.always,
                  //현재 페이지가 0이면 검정, 1이상이면 초록
                  valueIndicatorColor: isMyPageZero()
                      ? const Color.fromARGB(255, 76, 75, 73)
                      : Theme.of(context).textTheme.headline1!.color,
                  //슬라이더 바의 높이
                  trackHeight: 7,
                  inactiveTrackColor: Theme.of(context).backgroundColor,
                  activeTrackColor:
                      Theme.of(context).textTheme.headline1!.color,
                  thumbColor: isMyPageZero()
                      ? const Color.fromARGB(255, 76, 75, 73)
                      : Theme.of(context).textTheme.headline1!.color,
                  //질문) 오버레이는 thumb를 클릭할 시 클릭해서 움직이고 있다고 사용자에게 알려주기 위해서 thumb를 키워주는 것인데, 넣는게 좋을까?
                  overlayColor: isMyPageZero()
                      ? const Color.fromARGB(255, 76, 75, 73)
                      : Theme.of(context).textTheme.headline1!.color,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 15),
                ),
                child: Stack(
                  children: [
                    //showTrack(),
                    Slider(
                      /*value는 그 슬라이더 thumb의 위치를 나타낼 때 사용됨.
                      등록을 할 때에는 currentPage가 0으로 초기화 되어있고
                      등록된 책을 불러올 때에는 데이터베이스의 currentPage를 불러와야함.
                      */
                      value: widget.myBook.currentPage.toDouble(),
                      //thumb를 눌렀을 때 현재 value를 thumb위에 보여주는데 어떤 형태로 보여줄지 나타내는 것임
                      label: '${widget.myBook.currentPage.round().toString()}p',
                      min: 0,
                      max: widget.myBook.totalPage.toDouble(),
                      onChanged: updatePage,
                      onChangeEnd: savePage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
