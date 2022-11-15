import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' show Client, Response;
import 'package:movie_db/model/popular_movie.dart';

class ApiProvide {
  String apiKey= '745393cc8dcc8e8097ff9b6482981e59';
  String baseUrl = 'https://api.themoviedb.org/3';

  Client client = Client();

  Future<PopularMovies> getPopularMovie() async {
    String url = '$baseUrl/movie/popular?api_key=$apiKey';
        Response response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return PopularMovies.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load popular movies');
    }
  } 
}