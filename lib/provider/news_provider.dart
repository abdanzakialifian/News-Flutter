import 'package:flutter/cupertino.dart';
import 'package:news_app/data/model/article_result.dart';
import '../data/api/api_service.dart';

enum ResultState { loading, noData, hasData, error }

class NewsProvider extends ChangeNotifier {
  final ApiService apiService;

  late ArticlesResult _articlesResult;
  ArticlesResult get articleResult => _articlesResult;

  late ResultState _state;
  ResultState get resultState => _state;

  String _message = "";
  String get message => _message;

  NewsProvider({required this.apiService}) {
    _fetchAllArticle();
  }

  Future _fetchAllArticle() async {
    _state = ResultState.loading;
    notifyListeners();
    await apiService.topHeadline().then(
      (article) {
        if (article.articles?.isEmpty == true) {
          _state = ResultState.noData;
          notifyListeners();
          return _message = "Empty Data";
        } else {
          _state = ResultState.hasData;
          notifyListeners();
          return _articlesResult = article;
        }
      },
    ).catchError(
      (e) {
        _state = ResultState.error;
        notifyListeners();
        return _message = "Error ----> $e";
      },
    );
  }
}
