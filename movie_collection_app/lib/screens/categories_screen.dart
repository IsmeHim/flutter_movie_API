import 'package:flutter/material.dart';
import 'package:movie_collection_app/models/movie.dart';
import 'package:movie_collection_app/services/api_service.dart';
import 'package:movie_collection_app/screens/movie_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Movie>> futureMovies;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService().fetchMovies();
  }

  List<String> getCategories(List<Movie> movies) {
    final Set<String> categories = {'All'};
    for (var movie in movies) {
      categories.add(movie.genre);
    }
    return categories.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data!;
            final categories = getCategories(movies);
            final filteredMovies = selectedCategory == 'All'
                ? movies
                : movies.where((movie) => movie.genre == selectedCategory).toList();

            return Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category == selectedCategory;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? Colors.amber : Colors.grey[800],
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: filteredMovies.isEmpty
                      ? const Center(
                          child: Text(
                            'No movies available',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: filteredMovies.length,
                          itemBuilder: (context, index) {
                            final movie = filteredMovies[index];

                            return Card(
                              color: Colors.grey[900],
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: movie.imageUrl != null
                                      ? Image.network(
                                          movie.imageUrl!,
                                          width: 50,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 50,
                                              height: 70,
                                              color: Colors.black38,
                                              child: const Icon(Icons.broken_image, color: Colors.white),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 50,
                                          height: 70,
                                          color: Colors.black38,
                                          child: const Icon(Icons.movie, color: Colors.white),
                                        ),
                                ),
                                title: Text(
                                  movie.title,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                subtitle: Text(
                                  '${movie.director} (${movie.year})',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movie.id!)),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red, fontSize: 16)),
            );
          }
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        },
      ),
    );
  }
}
