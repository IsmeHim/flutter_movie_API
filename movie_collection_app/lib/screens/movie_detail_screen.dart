import 'package:flutter/material.dart';
import 'package:movie_collection_app/models/movie.dart';
import 'package:movie_collection_app/screens/edit_movie_screen.dart';
import 'package:movie_collection_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  // ignore: library_private_types_in_public_api
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> futureMovie;
  late bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    futureMovie = _loadMovie();
    _loadFavoriteStatus();
  }

  Future<Movie> _loadMovie() async {
    final movies = await ApiService().fetchMovies();
    return movies.firstWhere((m) => m.id == widget.movieId);
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds =
        prefs.getStringList('favoriteIds')?.map(int.parse).toList() ?? [];
    setState(() {
      isFavorite = favoriteIds.contains(widget.movieId);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds =
        prefs.getStringList('favoriteIds')?.map(int.parse).toList() ?? [];
    if (isFavorite) {
      favoriteIds.remove(widget.movieId);
    } else {
      favoriteIds.add(widget.movieId);
    }
    await prefs.setStringList(
      'favoriteIds',
      favoriteIds.map((id) => id.toString()).toList(),
    );
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Movie Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Movie>(
        future: futureMovie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movie = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildMovieImage(movie.imageUrl),
                  const SizedBox(height: 20),
                  _buildMovieDetails(movie),
                  const Spacer(),
                  _buildActionButtons(movie),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildMovieImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child:
          imageUrl != null
              ? Image.network(
                imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 200,
                    color: Colors.white,
                  );
                },
              )
              : const Icon(Icons.movie, size: 200, color: Colors.white),
    );
  }

  Widget _buildMovieDetails(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          movie.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Director: ${movie.director}',
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        Text(
          'Year: ${movie.year}',
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        Text(
          'Genre: ${movie.genre}',
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Movie movie) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
            size: 32, // ปรับขนาดไอคอนให้ใหญ่ขึ้น
          ),
          onPressed: _toggleFavorite,
        ),
        const SizedBox(height: 10), // เพิ่มช่องว่างให้ปุ่มดูสวยขึ้น
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditMovieScreen(movie: movie),
                  ),
                ).then((_) async {
                  final newFuture =
                      _loadMovie(); // หรือ await แล้ว Future.value() ก็ได้
                  setState(() {
                    futureMovie = newFuture;
                  });
                });
              },
              icon: const Icon(Icons.edit, color: Colors.black),
              label: const Text('Edit', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                bool confirm =
                    await showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                              'Are you sure you want to delete this movie?',
                              style: TextStyle(color: Colors.red),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    ) ??
                    false;

                if (confirm) {
                  await ApiService().deleteMovie(movie.id!);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              label: const Text('Back', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }
}
