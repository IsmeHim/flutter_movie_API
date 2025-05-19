import 'package:flutter/material.dart';
import 'package:movie_collection_app/screens/home_screen.dart';
import 'package:movie_collection_app/screens/about_me_screen.dart';
import 'package:movie_collection_app/screens/search_movies_screen.dart';
import 'package:movie_collection_app/screens/categories_screen.dart';
import 'package:movie_collection_app/screens/statistics_screen.dart';
import 'package:movie_collection_app/screens/gallery_screen.dart';
import 'package:movie_collection_app/screens/favorites_screen.dart';

void main() {
  runApp(const MovieCollectionApp());
}

class MovieCollectionApp extends StatelessWidget {
  const MovieCollectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/about_me': (context) => const AboutMeScreen(),
        '/search': (context) => const SearchMoviesScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/statistics': (context) => const StatisticsScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}