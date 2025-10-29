import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/di/service_locator.dart';
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
        title: const Text('Remover Usuário'),
        content: Text('Deseja remover ${user.name.first} ${user.name.last} dos salvos?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((value) {
      if (value == true) {
        savedUsersCubit.deleteUser(user.email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${user.name.first} ${user.name.last} removido'),
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
      appBar: AppBar(
        title: BlocBuilder<SavedUsersCubit, SavedUsersState>(
          bloc: savedUsersCubit,
          builder: (context, state) {
            return Text(
              'Usuários Salvos (${state.totalUsers})',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            );
          },
        ),
        centerTitle: false,
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
      ),
      body: BlocBuilder<SavedUsersCubit, SavedUsersState>(
        bloc: savedUsersCubit,
        builder: (context, state) {
          if (state.status == AppStatus.loading) {
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
                    onPressed: () => savedUsersCubit.loadSavedUsers(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (state.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Nenhum usuário salvo ainda', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text('Favorite usuários na tela principal', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return UserItem(user: user, onTap: () => _navigateToDetail(index), onDelete: () => _confirmDelete(index));
            },
          );
        },
      ),
    );
  }
}
