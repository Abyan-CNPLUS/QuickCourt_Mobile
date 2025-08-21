class Venue {
  final int id;
  final String name;
  final String address;
  final int capacity;
  final String price;
  final String status;
  final String category;
  final String city;
  final String? thumbnail;
  final String openTime;
  final String closeTime;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.capacity,
    required this.price,
    required this.status,
    required this.category,
    required this.city,
    this.thumbnail,
    required this.openTime,
    required this.closeTime,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        address: json['address'] ?? '',
        capacity: json['capacity'] ?? 0,
        price: json['price']?.toString() ?? '0',
        thumbnail: json['thumbnail'] ?? '',
        status: json['status'] ?? '',
        category: json['category']?['name'] ?? '',
        city: json['city']?['name'] ?? '',
        openTime: json['open_time'] ?? '',
        closeTime: json['close_time'] ?? '',
    );
  }

  
  String get imageUrl => thumbnail ?? '';
}
