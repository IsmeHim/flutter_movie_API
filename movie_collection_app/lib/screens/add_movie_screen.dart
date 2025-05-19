import 'package:flutter/material.dart';
import 'package:movie_collection_app/models/movie.dart';
import 'package:movie_collection_app/services/api_service.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String director = '';
  String year = '';
  String genre = '';
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField('Title', (value) => title = value!),
                    _buildTextField('Director', (value) => director = value!),
                    _buildTextField('Year', (value) => year = value!, isNumber: true),
                    _buildTextField('Genre', (value) => genre = value!),
                    _buildTextField('Image URL (optional)', (value) => imageUrl = value ?? '', isUrl: true),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton('Save', Colors.lightGreenAccent, Colors.black, _saveMovie),
                        _buildButton('Cancel', Colors.redAccent, Colors.white, () => Navigator.pop(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved, {bool isNumber = false, bool isUrl = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : (isUrl ? TextInputType.url : TextInputType.text),
        validator: (value) => value!.isEmpty ? 'Enter a $label' : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  void _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Movie newMovie = Movie(
        title: title,
        director: director,
        year: year,
        genre: genre,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      );
      await ApiService().addMovie(newMovie);
      if (mounted) Navigator.pop(context);
    }
  }
}
