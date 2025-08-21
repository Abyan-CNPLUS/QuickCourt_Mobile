class FnbMenu {
  final int id;
  final String name;
  final String image;
  final String? imageUrl;
  final int price;
  final int categoryId;

  FnbMenu({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.categoryId,
    this.imageUrl,
  });

  factory FnbMenu.fromJson(Map<String, dynamic> json) {
    return FnbMenu(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? '',
      imageUrl: json['image_url'],
      price: json['price'],
      categoryId: json['categories_id'],
    );
  }
}
