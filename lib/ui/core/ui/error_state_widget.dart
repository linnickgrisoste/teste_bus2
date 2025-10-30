import 'package:flutter/material.dart';
import 'package:teste_bus2/ui/core/styles/app_colors.dart';
import 'package:teste_bus2/ui/core/styles/app_fonts.dart';

class ErrorStateWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final String? title;
  final String? retryButtonText;

  const ErrorStateWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.title,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.errorBackground, shape: BoxShape.circle),
              child: Icon(Icons.error_outline, size: 48, color: AppColors.errorLight),
            ),
            const SizedBox(height: 24),
            Text(
              title ?? 'Ops! Algo deu errado',
              style: AppFonts.medium(18, AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: AppFonts.regular(14, AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 2,
              ),
              child: Text(
                retryButtonText ?? 'Tentar Novamente',
                style: AppFonts.medium(16, AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
