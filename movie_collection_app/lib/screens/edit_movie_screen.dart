import 'package:flutter/material.dart';
import 'package:movie_collection_app/models/movie.dart';
import 'package:movie_collection_app/services/api_service.dart';

class EditMovieScreen extends StatefulWidget {
  final Movie movie;

  const EditMovieScreen({super.key, required this.movie});

  @override
  // ignore: library_private_types_in_public_api
  _EditMovieScreenState createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String director;
  late String year;
  late String genre;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    title = widget.movie.title;
    director = widget.movie.director;
    year = widget.movie.year;
    genre = widget.movie.genre;
    imageUrl = widget.movie.imageUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: title,
                  decoration: const InputDecoration(labelText: 'Title',labelStyle: TextStyle(color: Colors.blue)),
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                  onSaved: (value) => title = value!,
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  initialValue: director,
                  decoration: const InputDecoration(labelText: 'Director',labelStyle: TextStyle(color: Colors.blue)),
                  validator: (value) => value!.isEmpty ? 'Enter a director' : null,
                  onSaved: (value) => director = value!,
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  initialValue: year,
                  decoration: const InputDecoration(labelText: 'Year',labelStyle: TextStyle(color: Colors.blue)),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter a year' : null,
                  onSaved: (value) => year = value!,
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  initialValue: genre,
                  decoration: const InputDecoration(labelText: 'Genre',labelStyle: TextStyle(color: Colors.blue)),
                  validator: (value) => value!.isEmpty ? 'Enter a genre' : null,
                  onSaved: (value) => genre = value!,
                  style: TextStyle(color: Colors.white),
                ),
                TextFormField(
                  initialValue: imageUrl,
                  decoration: const InputDecoration(labelText: 'Image URL (optional)',labelStyle: TextStyle(color: Colors.blue)),
                  keyboardType: TextInputType.url,
                  onSaved: (value) => imageUrl = value ?? '',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Movie updatedMovie = Movie(
                            id: widget.movie.id,
                            title: title,
                            director: director,
                            year: year,
                            genre: genre,
                            imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
                          );
                          await ApiService().updateMovie(updatedMovie);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Save',style: TextStyle(color: Colors.black),),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel',style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 