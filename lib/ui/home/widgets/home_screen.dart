import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/di/service_locator.dart';
import 'package:teste_bus2/ui/core/styles/app_colors.dart';
import 'package:teste_bus2/ui/core/styles/app_fonts.dart';
import 'package:teste_bus2/ui/core/ui/default_app_bar.dart';
import 'package:teste_bus2/ui/core/ui/empty_state_widget.dart';
import 'package:teste_bus2/ui/core/ui/error_state_widget.dart';
import 'package:teste_bus2/ui/core/ui/fade_slide_in.dart';
import 'package:teste_bus2/ui/core/ui/user_item.dart';
import 'package:teste_bus2/ui/home/view_model/home_cubit.dart';
import 'package:teste_bus2/ui/home/view_model/home_state.dart';
import 'package:teste_bus2/ui/saved_users/widgets/saved_users_screen.dart';
import 'package:teste_bus2/ui/user_detail/widgets/user_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final userCubit = ServiceLocator.get<HomeCubit>();

  @override
  void initState() {
    super.initState();
    userCubit.startUserFetching(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DefaultAppBar(
        title: 'Pessoas',
        actions: [
          FadeSlideIn(
            enabled: true,
            beginOffsetY: 0.2,
            curve: Curves.easeOutCubic,
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 300),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedUsersScreen()));
              },
              icon: const Icon(Icons.storage),
              tooltip: 'Usuários Salvos',
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: userCubit,
        builder: (context, state) {
          if (state.status == AppStatus.loading && state.users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
            );
          }

          if (state.status == AppStatus.error) {
            return ErrorStateWidget(
              errorMessage: state.errorMessage,
              onRetry: () => context.read<HomeCubit>().fetchUsers(),
            );
          }

          if (state.status == AppStatus.success || state.users.isNotEmpty) {
            final users = state.users;

            if (users.isEmpty) {
              return const EmptyStateWidget(icon: Icons.people_outline, title: 'Nenhum usuário encontrado');
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FadeSlideIn(
                        enabled: true,
                        beginOffsetY: 0.2,
                        curve: Curves.easeOutCubic,
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 300),
                        child: UserItem(
                          user: user,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserDetailScreen(user: user)),
                            );
                          },
                        ),
                      ),
                    ),
                    if (state.isLoading && index == users.length - 1)
                      LinearProgressIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.grey200,
                        borderRadius: BorderRadius.circular(32),
                      ),
                  ],
                );
              },
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
                const SizedBox(height: 16),
                Text('Carregando usuários...', style: AppFonts.medium(16, AppColors.textSecondary)),
              ],
            ),
          );
        },
      ),
    );
  }
}
