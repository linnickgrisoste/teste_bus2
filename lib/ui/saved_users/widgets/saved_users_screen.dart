import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/di/service_locator.dart';
import 'package:teste_bus2/ui/core/styles/app_colors.dart';
import 'package:teste_bus2/ui/core/styles/app_fonts.dart';
import 'package:teste_bus2/ui/core/ui/default_app_bar.dart';
import 'package:teste_bus2/ui/core/ui/empty_state_widget.dart';
import 'package:teste_bus2/ui/core/ui/error_state_widget.dart';
import 'package:teste_bus2/ui/core/ui/user_item.dart';
import 'package:teste_bus2/ui/saved_users/view_model/saved_users_cubit.dart';
import 'package:teste_bus2/ui/saved_users/view_model/saved_users_state.dart';
import 'package:teste_bus2/ui/user_detail/widgets/user_detail_screen.dart';

class SavedUsersScreen extends StatefulWidget {
  const SavedUsersScreen({super.key});

  @override
  State<SavedUsersScreen> createState() => _SavedUsersScreenState();
}

class _SavedUsersScreenState extends State<SavedUsersScreen> {
  late final SavedUsersCubit savedUsersCubit;

  @override
  void initState() {
    super.initState();
    savedUsersCubit = ServiceLocator.get<SavedUsersCubit>();
    savedUsersCubit.loadSavedUsers();
  }

  Future<void> _navigateToDetail(int index) async {
    final user = savedUsersCubit.state.users[index];
    await Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(user: user)));
    savedUsersCubit.loadSavedUsers();
  }

  Future<void> _confirmDelete(int index) async {
    final user = savedUsersCubit.state.users[index];
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remover Usuário', style: AppFonts.medium(18, AppColors.textPrimary)),
        content: Text(
          'Deseja remover ${user.name.first} ${user.name.last} dos salvos?',
          style: AppFonts.regular(14, AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
            child: Text('Cancelar', style: AppFonts.medium(14, AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text('Remover', style: AppFonts.medium(14, AppColors.white)),
          ),
        ],
      ),
    ).then((value) {
      if (value == true) {
        savedUsersCubit.deleteUser(user.email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${user.name.first} ${user.name.last} removido',
                style: AppFonts.regular(14, AppColors.white),
              ),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DefaultAppBar(title: 'Usuários Salvos (${savedUsersCubit.state.totalUsers})'),
      body: BlocBuilder<SavedUsersCubit, SavedUsersState>(
        bloc: savedUsersCubit,
        builder: (context, state) {
          if (state.status == AppStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
            );
          }

          if (state.status == AppStatus.error) {
            return ErrorStateWidget(errorMessage: state.errorMessage, onRetry: () => savedUsersCubit.loadSavedUsers());
          }

          if (state.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.favorite_border,
              title: 'Nenhum usuário salvo ainda',
              subtitle: 'Favorite usuários na tela principal',
              iconBackgroundColor: AppColors.softWhite,
              iconColor: AppColors.primary,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: UserItem(
                  user: user,
                  onTap: () => _navigateToDetail(index),
                  onDelete: () => _confirmDelete(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
