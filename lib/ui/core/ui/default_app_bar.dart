import 'package:flutter/material.dart';
import 'package:teste_bus2/ui/core/styles/app_colors.dart';
import 'package:teste_bus2/ui/core/styles/app_fonts.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const DefaultAppBar({super.key, required this.title, this.actions, this.leading, this.centerTitle = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppFonts.medium(20, AppColors.white)),
      centerTitle: centerTitle,
      leading: leading,
      flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.white,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
