import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/di/service_locator.dart';
import 'package:teste_bus2/ui/core/ui/empty_state_widget.dart';
import 'package:teste_bus2/ui/core/ui/error_state_widget.dart';
import 'package:teste_bus2/ui/core/ui/themed_app_bar.dart';
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
      backgroundColor: Colors.grey.shade50,
      appBar: ThemedAppBar(
        title: 'Pessoas',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedUsersScreen()));
            },
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Usuários Salvos',
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: userCubit,
        builder: (context, state) {
          if (state.status == AppStatus.loading && state.users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5E72E4))),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
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
                    if (state.isLoading && index == users.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: LinearProgressIndicator(
                          color: const Color(0xFF5E72E4),
                          backgroundColor: Colors.grey.shade200,
                        ),
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
                const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5E72E4))),
                const SizedBox(height: 16),
                Text('Carregando usuários...', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              ],
            ),
          );
        },
      ),
    );
  }
}
