import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teste_bus2/data/models/user_model.dart';

class UserItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;

  const UserItem({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: CachedNetworkImageProvider(user.picture.thumbnail),
              backgroundColor: Colors.grey[300],
              child: CachedNetworkImage(
                imageUrl: user.picture.thumbnail,
                errorWidget: (context, url, error) => Icon(Icons.person, size: 32, color: Colors.grey[600]),
                imageBuilder: (context, imageProvider) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name.first} ${user.name.last}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text('${user.dob.age} anos — ${user.nat}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
