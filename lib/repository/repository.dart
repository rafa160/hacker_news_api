import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:news_hacker_app/models/stories_model.dart';

class Repository {
  final _httpClient = http.Client();
  static const api = 'https://hacker-news.firebaseio.com/v0/topstories.json';
  void dispose() {
    _httpClient.close();
  }

  Future<List<int>> loadNewsIds() async {
    final response = await _httpClient.get(api);
    if (response.statusCode != 200) throw http.ClientException('Failed to load top story ids');

    return List<int>.from(json.decode(response.body));
  }

  Future<StoriesModel> loadNewById(int id) async {
    final response = await _httpClient.get('https://hacker-news.firebaseio.com/v0/item/$id.json');
    if (response.statusCode != 200) throw http.ClientException('Failed to load story with id $id');

    return StoriesModel.fromJson(json.decode(response.body));
  }
}