class BookMemoModel {
  String title, id;
  String phrase, memo;
  String date;
  int myKey;
  // late DateTime date;

  BookMemoModel({
    required this.myKey,
    required this.id,
    required this.title,
    required this.phrase,
    required this.memo,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'myKey': myKey,
      'id': id,
      'title': title,
      'phrase': phrase,
      'memo': memo,
      'date': date,
    };
  }

  // BookMemoModel.fromMap(Map<dynamic, dynamic>? map) {
  //   myKey = map?['myKey'];
  //   id = map?['id'];
  //   title = map?['title'];
  //   phrase = map?['phrase'];
  //   memo = map?['memo'];
  //   date = map?['date'];
  // }

  @override
  String toString() {
    return 'BookMemoModel(myKey : $myKey, id : $id, title : $title, phrase : $phrase, memo : $memo, date : $date)';
  }
}
