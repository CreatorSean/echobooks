class BookModel {
  final String title, id, image, info;
  String author = "unknown";
  int totalPage = 1000;
  int currentPage = 0;
  int readDone = 0;

  BookModel({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.info,
    required this.totalPage,
    required this.currentPage,
    required this.readDone,
  });

// <알라딘> API 모델
  // BookModel.fromJson(Map<String, dynamic> json)
  //     : title = json['title'],
  //       id = json['isbn'],
  //       image = json['cover'],
  //       author = json['author'],
  //       info = json['description'],
  //       totalPage = json['itemPage'];

// <카카오> API 모델
  BookModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['isbn'],
        image = json['thumbnail'].length > 0 ? json['thumbnail'] : "icon",
        author = json['authors'].length > 0 ? json['authors'][0] : "unknown",
        info = json['contents'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'author': author,
      'info': info,
      'totalPage': totalPage,
      'currentPage': currentPage,
      'readDone': readDone,
    };
  }
}
