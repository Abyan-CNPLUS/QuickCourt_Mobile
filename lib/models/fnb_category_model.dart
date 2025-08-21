class FnbCategory {
  final int id;
  final String name;

  FnbCategory({required this.id, required this.name});

  factory FnbCategory.fromJson(Map<String, dynamic> json) {
    return FnbCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}
