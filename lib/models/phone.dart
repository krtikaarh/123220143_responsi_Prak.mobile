class Phone {
  final int id;
  final String name;
  final String image;
  final int price;
  final String brand;
  final String specification;

  Phone({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.brand,
    required this.specification,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['img_url']?.toString() ?? '',
      price:
          json['price'] is int
              ? json['price']
              : int.tryParse(json['price'].toString()) ?? 0,
      brand: json['brand']?.toString() ?? '',
      specification: json['specification']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'brand': brand,
      'specification':specification, 
    };
  }
  Map<String, dynamic> toJsonwithId() {
    return {
      'name': name,
      'brand': brand,
      'price': price,
      'specification': specification,
      'img_url': image,
    };
  }
}

