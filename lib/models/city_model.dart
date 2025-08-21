class City {
  final int id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Venue {
  final int id;
  final String name;
  final String address;
  final String image;
  final String category;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.category,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['thumbnail'] ?? '', 
      category: json['category']?['name'] ?? 'default',
    );
  }
}
