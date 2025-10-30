import 'package:flutter/material.dart';
import 'package:teste_bus2/ui/core/styles/app_colors.dart';
import 'package:teste_bus2/ui/core/styles/app_fonts.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconBackgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = iconBackgroundColor ?? AppColors.grey200;
    final icColor = iconColor ?? AppColors.textHint;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, size: 64, color: icColor),
          ),
          const SizedBox(height: 24),
          Text(title, style: AppFonts.medium(18, AppColors.textSecondary), textAlign: TextAlign.center),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle ?? '', style: AppFonts.regular(14, AppColors.textTertiary), textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
