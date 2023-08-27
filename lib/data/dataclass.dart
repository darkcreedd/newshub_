import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newshub_tabview/Models/newsmodel.dart';
import 'package:http/http.dart' as http;

class DataClass extends ChangeNotifier {
//General Function
  String apiKey = 'e7763632fbda4970b39ed7a6dbdf20c2';
  Future<List<Article>?>? generalArticles;
  Future<List<Article>?>? fetchGNews(String country) async {
    try {
      String url =
          'https://newsapi.org/v2/top-headlines?country=$country&category=general&apiKey=$apiKey&pageSize=100';
      Uri uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        debugPrint(generalArticles.toString());
        notifyListeners();
        return News.fromJson(jsonDecode(response.body)).articles;
      } else {
        throw Exception();
      }
    } catch (e) {
      (e.toString());
    }
    notifyListeners();
    return null;
  }

  String matchcountry(String source) {
    String match;
    switch (source) {
      case 'US':
        match = 'us';
        break;
      case 'UK':
        match = 'uk';
        break;
      case 'Canada':
        match = 'ca';
        break;
      case 'China':
        match = 'cn';
        break;
      case 'Germany':
        match = 'de';
        break;
      case 'Japan':
        match = 'jp';
        break;
      case 'South Africa':
        match = 'za';
        break;
      case 'Russia':
        match = 'ua';
        break;

      default:
        match = 'us';
    }
    return match;
  }

  //Business Function
  Future<List<Article>?>? businessArticles;
  Future<List<Article>?>? fetchBNews(String country) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=$country&category=business&apiKey=$apiKey';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      notifyListeners();

      return News.fromJson(jsonDecode(response.body)).articles;
    } else {
      throw Exception;
    }
  }

//Entertainment
  Future<List<Article>?>? entertainmentArticles;
  Future<List<Article>?>? fetchENews(String country) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=$country&category=entertainment&apiKey=$apiKey';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      notifyListeners();
      return News.fromJson(jsonDecode(response.body)).articles;
    } else {
      throw Exception;
    }
  }

//Sports
  Future<List<Article>?>? sportsArticles;
  Future<List<Article>?>? fetchSNews(String country) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=$country&category=sports&apiKey=$apiKey';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      notifyListeners();

      return News.fromJson(jsonDecode(response.body)).articles;
    } else {
      throw Exception;
    }
  }

//Health
  Future<List<Article>?>? healthArticles;
  Future<List<Article>?>? fetchHNews(String country) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=$country&category=health&apiKey=$apiKey';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      notifyListeners();

      return News.fromJson(jsonDecode(response.body)).articles;
    } else {
      throw Exception;
    }
  }

//Science
  Future<List<Article>?>? scienceArticles;
  Future<List<Article>?>? fetchScNews(String country) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=$country&category=science&apiKey=$apiKey';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      notifyListeners();

      return News.fromJson(jsonDecode(response.body)).articles;
    } else {
      throw Exception;
    }
  }

//Technology
  Future<List<Article>?>? technologyArticles;
  Future<List<Article>?>? fetchTNews(String country) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=$country&category=technology&apiKey=$apiKey&pageSize=100';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      notifyListeners();
      return News.fromJson(jsonDecode(response.body)).articles;
    } else {
      throw Exception;
    }
  }

  List<CustomArticle> bookmarkedArticles = [];
  removeFromBookmarked(int idx) {
    bookmarkedArticles.removeWhere((article) => article.id == idx);
    notifyListeners();
  }

  addToBookmark(
    headline,
    description,
    content,
    imageLink,
    url,
    source,
    author,
    date,
    bookmarked,
    id,
  ) {
    List<CustomArticle> articlesToAdd = [];

    if (bookmarkedArticles.isNotEmpty) {
      for (final article in bookmarkedArticles) {
        if (article.id != id) {
          articlesToAdd.add(
            CustomArticle(
              id: id,
              author: author,
              content: content,
              bookmarked: bookmarked,
              description: description,
              headline: headline,
              imageLink: imageLink,
              url: url,
              publishedAt: date,
              source: source,
            ),
          );
        }
      }
    } else {
      articlesToAdd.add(
        CustomArticle(
          id: id,
          author: author,
          content: content,
          bookmarked: bookmarked,
          description: description,
          headline: headline,
          imageLink: imageLink,
          url: url,
          publishedAt: date,
          source: source,
        ),
      );
    }

    bookmarkedArticles.addAll(articlesToAdd);
    print(bookmarkedArticles.length);
    notifyListeners();
  }

  reload(String country) {
    generalArticles = fetchGNews(country);
    businessArticles = fetchBNews(country);
    entertainmentArticles = fetchENews(country);
    healthArticles = fetchHNews(country);
    sportsArticles = fetchSNews(country);
    scienceArticles = fetchScNews(country);
    technologyArticles = fetchTNews(country);
  }
}

class CustomArticle {
  CustomArticle(
      {this.author,
      this.content,
      required this.id,
      required this.publishedAt,
      required this.bookmarked,
      this.description,
      required this.headline,
      this.imageLink,
      this.source,
      required this.url});
  String headline, url;
  bool bookmarked;
  int id;
  DateTime publishedAt;
  String? description, source, imageLink, content, author;
}
