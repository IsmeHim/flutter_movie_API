import 'package:flutter/material.dart';
import 'package:movie_collection_app/models/movie.dart';
import 'package:movie_collection_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_collection_app/screens/movie_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<int> favoriteIds = [];
  List<Movie> favoriteMovies = [];
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    futureMovies = ApiService().fetchMovies();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteIds = prefs.getStringList('favoriteIds')?.map(int.parse).toList() ?? [];
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteIds', favoriteIds.map((id) => id.toString()).toList());
  }

  void _toggleFavorite(Movie movie) {
    setState(() {
      if (favoriteIds.contains(movie.id)) {
        favoriteIds.remove(movie.id);
      } else {
        favoriteIds.add(movie.id!);
      }
    });
    _saveFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final allMovies = snapshot.data!;
            favoriteMovies = allMovies.where((movie) => favoriteIds.contains(movie.id)).toList();

            return favoriteMovies.isEmpty
                ? const Center(
                    child: Text(
                      'No favorite movies yet!',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: favoriteMovies.length,
                    itemBuilder: (context, index) {
                      final movie = favoriteMovies[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: movie.imageUrl != null
                              ? Image.network(
                                  movie.imageUrl!,
                                  width: 80,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 120,
                                      color: Colors.grey[700],
                                      child: const Icon(Icons.broken_image, color: Colors.white70),
                                    );
                                  },
                                )
                              : Container(
                                  width: 80,
                                  height: 120,
                                  color: Colors.grey[700],
                                  child: const Icon(Icons.movie, color: Colors.white70),
                                ),
                          title: Text(
                            movie.title,
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          subtitle: Text(
                            '${movie.director} (${movie.year})',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: favoriteIds.contains(movie.id) ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(movie),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movie.id!)),
                            ).then((_) {
                              _loadFavorites(); // รีเฟรช Favorites ด้วย
                            });
                          },
                        ),
                      );
                    },
                  );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)),
            );
          }
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        },
      ),
    );
  }
}