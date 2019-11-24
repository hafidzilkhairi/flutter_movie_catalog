import 'dart:convert';

import 'package:flutter_movie_catalog/model/popular_movies.dart';
import 'package:http/http.dart';

class ApiProvider {
  String apiKey = '';
  String baseUrl = 'https://api.themoviedb.org/3';

  Client client = Client();

  Future<PopularMovies> getPopularMovies() async {
    Response response = await client.get('$baseUrl/movie/popular?api_key=$apiKey');

    if (response.statusCode == 200) {
      return PopularMovies.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }
  
}