class Phone {
  final int id;
  final String name;
  final String image;
  final int price;

  Phone({required this.id, required this.name, required this.image, required this.price});

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}
