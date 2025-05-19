import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/movie_api2/'; // อัปเดตที่นี่

 // ฟังก์ชัน fetchMovies() (ดึงรายการภาพยนตร์ทั้งหมด)
  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies: Status ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> addMovie(Movie movie) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(movie.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add movie: ${response.body}');
    }
  }

  Future<void> updateMovie(Movie movie) async {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(movie.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update movie: ${response.body}');
    }
  }

  Future<void> deleteMovie(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl?id=$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete movie: ${response.body}');
    }
  }
}