import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/di/service_locator.dart';
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
      appBar: AppBar(
        title: const Text('Pessoas', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        centerTitle: false,
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedUsersScreen()));
            },
            icon: const Icon(Icons.storage),
            tooltip: 'Usuários Salvos',
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: userCubit,
        builder: (context, state) {
          if (state.status == AppStatus.loading && state.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AppStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.errorMessage, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().fetchUsers();
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (state.status == AppStatus.success || state.users.isNotEmpty) {
            final users = state.users;

            if (users.isEmpty) {
              return const Center(child: Text('Nenhum usuário encontrado'));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    UserItem(
                      user: user,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(user: user)));
                      },
                    ),
                    Visibility(visible: state.isLoading && index == users.length - 1, child: LinearProgressIndicator()),
                  ],
                );
              },
            );
          }

          return const Center(child: Text('Carregando usuários...'));
        },
      ),
    );
  }
}
