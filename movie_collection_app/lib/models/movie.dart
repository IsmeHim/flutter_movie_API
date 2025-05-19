class Movie {
  int? id; // ตัวแปรเก็บ ID ของหนัง (อาจเป็น null ได้)
  String title;
  String director;
  String year;
  String genre;
  String? imageUrl; 

  // Constructor สำหรับสร้างอ็อบเจ็กต์ Movie
  Movie({
    this.id,
    required this.title,
    required this.director,
    required this.year,
    required this.genre,
    this.imageUrl,
  });

  // Factory constructor สำหรับแปลง JSON เป็นอ็อบเจ็กต์ Movie รับค่าจาก JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null, // แปลง id เป็น int หากไม่ใช่ null
      title: json['title'],
      director: json['director'],
      year: json['year'],
      genre: json['genre'],
      imageUrl: json['image_url'],
    );
  }

// ฟังก์ชันสำหรับแปลงอ็อบเจ็กต์ Movie เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'director': director,
      'year': year,
      'genre': genre,
      'image_url': imageUrl,
    };
  }
}