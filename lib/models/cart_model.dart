class CartItem {
  final int? cartId;
  final int menuId;
  final String name;
  final int price;
  final String? imageUrl;
  int qty;

  CartItem({
    this.cartId,
    required this.menuId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.qty = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        cartId: json['id'],
        menuId: (json['fnb_menu_id'] ?? json['menu_id'] ?? 0) as int,
        name: json['name'],
        price: (json['price'] is String)
        ? int.tryParse(json['price']) ?? 0
        : (json['price'] ?? 0),
        imageUrl: json['image_url'],
        qty: json['quantity'] ?? json['qty'] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'fnb_menu_id': menuId,
        'quantity': qty,
        'price': price,
      };
}