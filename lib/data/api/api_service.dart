import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/data/model/article_result.dart';

class ApiService {
  static const String _baseUrl = "https://newsapi.org/v2/";
  static const String _apiKey = "e5342c5afe884cb29b46eb4d2fb5e2b5";
  static const String _category = "business";
  static const String _country = "id";

  Future<ArticlesResult> topHeadline() async {
    String url =
        "${_baseUrl}top-headlines?country=$_country&category=$_category&apiKey=$_apiKey";
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      return ArticlesResult.fromJson(json.decode(response.body));
    } else {
      return throw Exception("Failed to load top headlines");
    }
  }
}
