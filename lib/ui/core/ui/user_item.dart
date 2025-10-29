import 'package:flutter/material.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';
import 'package:teste_bus2/ui/core/ui/default_cached_network_image.dart';

class UserItem extends StatelessWidget {
  final UserEntity user;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const UserItem({super.key, required this.user, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              child: DefaultCachedNetworkImage(imageUrl: user.picture.thumbnail, size: 56),
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
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                tooltip: 'Remover',
              ),
          ],
        ),
      ),
    );
  }
}
