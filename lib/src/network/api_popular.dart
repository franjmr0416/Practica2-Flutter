import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:practica2/src/models/cast_movie_model.dart';
import 'package:practica2/src/models/popular_movies_model.dart';
import 'package:practica2/src/models/video_movie_model.dart';

class ApiPopular {
  var URL = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=e2dc6a6246da72420a469e4a398c0874&language=es-MX&page=1');

  Future<List<PopularMoviesModel>?> getAllPopular() async {
    final response = await http.get(URL);
    if (response.statusCode == 200) {
      var popular = jsonDecode(response.body)['results'] as List;
      List<PopularMoviesModel> listPopular =
          popular.map((movie) => PopularMoviesModel.fromMap(movie)).toList();
      return listPopular;
    } else {
      return null;
    }
  }

  Future<List<CastMovieModel>?> getCastById(String id) async {
    var URLCAST = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/credits?api_key=e2dc6a6246da72420a469e4a398c0874&language=es-MX');
    final response = await http.get(URLCAST);
    if (response.statusCode == 200) {
      var cast = jsonDecode(response.body)['cast'] as List;
      List<CastMovieModel> listCast =
          cast.map((map) => CastMovieModel.fromMap(map)).toList();

      return listCast;
    } else {
      return null;
    }
  }

  Future<List<VideoMovieModel>?> getVideoById(String id) async {
    var URLVIDEO = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/videos?api_key=e2dc6a6246da72420a469e4a398c0874&language=es-MX');
    final response = await http.get(URLVIDEO);
    if (response.statusCode == 200) {
      var videos = jsonDecode(response.body)['results'] as List;
      List<VideoMovieModel> listVideos =
          videos.map((map) => VideoMovieModel.fromMap(map)).toList();
      print(videos.toList());
      return listVideos;
    } else {
      return null;
    }
  }
}
