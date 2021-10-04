import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica2/src/models/popular_movies_model.dart';

class ApiPopular {
  var URL = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=e2dc6a6246da72420a469e4a398c0874&language=es-MX&page=1');

  Future<List<PopularMoviesModel>?> getAllPopular() async {
    final response = await http.get(URL);
    if (response.statusCode == 200) {
      var popular = jsonDecode(response.body)['results'] as List;
      List<PopularMoviesModel> listPopular =
          popular.map((movie) => PopularMoviesModel.fromMap(movie)).toList();
    } else {
      return null;
    }
  }
}
