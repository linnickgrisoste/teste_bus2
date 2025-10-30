import 'package:flutter/material.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';
import 'package:teste_bus2/ui/core/styles/app_colors.dart';
import 'package:teste_bus2/ui/core/styles/app_fonts.dart';
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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: AppColors.shadowLight, blurRadius: 8, offset: const Offset(0, 2)),
          ],
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.grey200,
              child: DefaultCachedNetworkImage(imageUrl: user.picture.thumbnail, size: 56),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name.first} ${user.name.last}',
                    style: AppFonts.medium(16, AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text('${user.dob.age} anos — ${user.nat}', style: AppFonts.regular(14, AppColors.textSecondary)),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                color: AppColors.error,
                tooltip: 'Remover',
              ),
          ],
        ),
      ),
    );
  }
}
