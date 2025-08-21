class CartItemModel {
  final int id;
  final int userId;
  final int menuId;
  final String name;
  final int price; // simpan sebagai int, tapi parsing fleksibel
  final int quantity;
  final String imageUrl;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.menuId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      menuId: json['fnb_menu_id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] is String)
          ? int.tryParse(json['price']) ?? 0
          : (json['price'] ?? 0).toInt(),
      quantity: json['quantity'] ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'fnb_menu_id': menuId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
    };
  }

  int get total => price * quantity;

  
  int get qty => quantity;
}
