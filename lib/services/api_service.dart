import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey;
  final String baseUrl = 'https://api.themoviedb.org/3';

  ApiService({required this.apiKey});

  Future<List<dynamic>> fetchPopularMovies() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<dynamic>> fetchGenres() async {
    final response = await http.get(
        Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['genres'];
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<dynamic>> fetchMoviesByGenre(int genreId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=en-US'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<dynamic>> fetchLatestMovies() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/movie/now_playing?api_key=$apiKey&language=en-US&page=1'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load latest movies');
    }
  }
}
