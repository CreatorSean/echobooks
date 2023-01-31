import 'dart:convert';

import 'package:echobooks/models/book_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String kakaoRestApiKey = "c52bf52734a689e1bb461adbef29ec9e";
  static const String baseUrl =
      "https://dapi.kakao.com/v3/search/book?target=title";

  static Future<List<BookModel>> getSearchBooksByQuery(String query) async {
    List<BookModel> bookInstances = [];

    final url = Uri.parse("$baseUrl&query=$query");
    final response = await http
        .get(url, headers: {"Authorization": "KakaoAK $kakaoRestApiKey"});

    if (response.statusCode == 200) {
      final Map<String, dynamic> document = jsonDecode(response.body);
      final List<dynamic> books = document["documents"];
      // print(books);
      for (var book in books) {
        bookInstances.add(BookModel.fromJson(book));
      }
      return bookInstances;
    }
    throw Error();
  }
}


// <알라딘> API
// class ApiService {
//   static const String TTBKey = "ttblowsky20132001";
//   late String Query;

//   static const String baseUrl =
//       "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx";
//   late String query;
//   static const String output = "JS";

//   static Future<List<BookModel>> getBooks() async {
//     List<BookModel> bookInstances = [];

//     final url =
//         Uri.parse("$baseUrl?&ttbkey=[$TTBKey]&Query=미쳐도&output=$output");
//     final response = await http.get(
//       url
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> books = jsonDecode(response.body);
//       print(books);
//       // for (var book in books) {
//       //   print(BookModel.fromJson(book));
//       //   bookInstances.add(BookModel.fromJson(book));
//       // }
//       return bookInstances;
//     }
//     throw Error();
//   }
// }

