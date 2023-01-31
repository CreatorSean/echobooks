import 'package:echobooks/models/book_model.dart';
import 'package:flutter/material.dart';

class EnrollButtonWidget extends StatelessWidget {
  final Function onEnrollTap;
  final Function updateHomeScreen;
  final BookModel bookModel;

  const EnrollButtonWidget({
    super.key,
    required this.onEnrollTap,
    required this.bookModel,
    required this.updateHomeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).textTheme.headline1!.color,
        foregroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 50,
        ),
      ),
      //1.책정보를 BookDataBase에 저장, 2.첫페이지로 이동하는 함수입니다.
      onPressed: (() async {
        onEnrollTap();
        Navigator.of(context).popUntil((route) => route.isFirst);
        updateHomeScreen();
      }),
      child: const Text(
        '등록',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
