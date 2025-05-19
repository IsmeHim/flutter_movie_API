import 'package:flutter/material.dart';
import 'package:movie_collection_app/models/movie.dart';
import 'package:movie_collection_app/services/api_service.dart';
import 'package:movie_collection_app/screens/movie_detail_screen.dart';

class SearchMoviesScreen extends StatefulWidget {
  const SearchMoviesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchMoviesScreenState createState() => _SearchMoviesScreenState();
}

class _SearchMoviesScreenState extends State<SearchMoviesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> movies = [];
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService().fetchMovies();
  }

  void _searchMovies(String query) async {
    final allMovies = await futureMovies;
    setState(() {
      movies = allMovies
          .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 10),
            Expanded(child: _buildMovieList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: _searchMovies,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.deepPurple.shade700,
        hintText: 'Search by title...',
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  Widget _buildMovieList() {
    return FutureBuilder<List<Movie>>(
      future: futureMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
        } else if (movies.isEmpty) {
          return const Center(child: Text('No movies found', style: TextStyle(color: Colors.white70, fontSize: 16)));
        } else {
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _buildMovieCard(movies[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      color: Colors.deepPurple.shade600,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: movie.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(movie.imageUrl!, width: 50, height: 75, fit: BoxFit.cover),
              )
            : const Icon(Icons.movie, size: 50, color: Colors.white70),
        title: Text(movie.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('${movie.director} (${movie.year})', style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movie.id!)),
          );
        },
      ),
    );
  }
}
