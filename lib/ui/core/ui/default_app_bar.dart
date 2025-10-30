import 'package:flutter/material.dart';
import 'package:teste_bus2/ui/core/styles/app_colors.dart';
import 'package:teste_bus2/ui/core/styles/app_fonts.dart';
import 'package:teste_bus2/ui/core/ui/fade_slide_in.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const DefaultAppBar({super.key, required this.title, this.actions, this.leading, this.centerTitle = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FadeSlideIn(
        delay: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 300),
        beginOffsetY: 0.2,
        curve: Curves.easeOutCubic,
        enabled: true,
        child: Text(title, style: AppFonts.medium(20, AppColors.white)),
      ),
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
