import 'package:flutter/material.dart';
import '../models/phone.dart';

class PhoneCard extends StatelessWidget {
  final Phone phone;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const PhoneCard({
    Key? key,
    required this.phone,
    this.onTap,
    this.onDelete,
    this.onFavorite,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        onTap: onTap,
        leading: Image.network(
          phone.image,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.phone_android),
        ),
        title: Text(phone.name),
        subtitle: Text('Rp ${phone.price}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              color: isFavorite ? Colors.red : null,
              onPressed: onFavorite,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
