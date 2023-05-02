import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:quantum_assignment/constants.dart';
import 'package:quantum_assignment/services/api_service.dart';
import 'package:quantum_assignment/services/connection_service.dart';
import '../models/news.dart';

class NewsService extends ChangeNotifier{
  List<News> _newsList = [];
  List<News> get newsList => _newsList;
  get size => _newsList.length;

  Future<void> loadNews() async {
    final connectionService = ConnectionService();
    Box<News> newsBox = await Hive.openBox('newsBox');
    _newsList.clear();
    refresh();
    if(await connectionService.isConnectedToInternet()){
      Map<String, dynamic> response = await ApiService.get(apiUrl);
      _newsList = List<News>.from(response["articles"].map((x) => News.fromJson(x)));
      print("Fetch News");
      await newsBox.clear();
      await newsBox.addAll(newsList);
    }
    else{
      _newsList = List.from(newsBox.values);
    }
    refresh();
  }

  refresh(){
    notifyListeners();
  }
}