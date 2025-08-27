class BookingOwner {
  final int id;
  final String userName;
  final String venueName;
  final String venueCity;
  final String imageUrl;
  final String status;
  final String date;
  final String time;
  final int totalPrice;
  final String? userPhotoUrl;

  BookingOwner({
    required this.id,
    required this.userName,
    required this.venueName,
    required this.venueCity,
    required this.imageUrl,
    required this.status,
    required this.date,
    required this.time,
    required this.totalPrice,
    this.userPhotoUrl,
  });

  factory BookingOwner.fromJson(Map<String, dynamic> json) {
    final venue = json['venue'] ?? {};
    final city = venue['city'] ?? {};
    final primaryImage = venue['primary_image'] ?? {};
    final user = json['user'] ?? {};

    String imagePath = '';
    if (primaryImage['image_url'] != null) {
      imagePath =
          "http://192.168.1.12:8000/storage/${primaryImage['image_url']}";
    }

    String? userPhotoPath;
    if (user['photo_url'] != null) {
      userPhotoPath = "http://192.168.1.12:8000/storage/${user['photo_url']}";
    }

    return BookingOwner(
      id: json['id'],
      userName: user['name'] ?? 'User',
      venueName: venue['name'] ?? '',
      venueCity: city['name'] ?? '',
      imageUrl: imagePath,
      status: json['status'] ?? '',
      date: json['booking_date']?.toString().substring(0, 10) ?? '',
      time: "${json['start_time'] ?? ''} - ${json['end_time'] ?? ''}",
      userPhotoUrl: userPhotoPath,
      totalPrice: (double.tryParse(json['total_price']?.toString() ?? '0') ?? 0)
          .toInt(),
    );
  }

  BookingOwner copyWith({String? status}) {
    return BookingOwner(
      id: id,
      userName: userName,
      venueName: venueName,
      venueCity: venueCity,
      imageUrl: imageUrl,
      status: status ?? this.status,
      date: date,
      time: time,
      totalPrice: totalPrice,
      userPhotoUrl: userPhotoUrl,
    );
  }
}
