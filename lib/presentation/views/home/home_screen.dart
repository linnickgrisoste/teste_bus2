import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/presentation/cubits/user_cubit.dart';
import 'package:teste_bus2/presentation/cubits/user_state.dart';
import 'package:teste_bus2/presentation/views/user_detail/user_detail_screen.dart';
import 'package:teste_bus2/presentation/views/widgets/user_item.dart';
import 'package:teste_bus2/support/service_locator/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final userCubit = ServiceLocator.get<UserCubit>();

  @override
  void initState() {
    super.initState();
    userCubit.startUserFetching(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pessoas', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          centerTitle: false,
          elevation: 2,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.storage))],
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserCubit>().fetchUsers();
                      },
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              );
            }

            if (state is UserSuccess) {
              final users = state.users;

              if (users.isEmpty) {
                return const Center(child: Text('Nenhum usuário encontrado'));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return UserItem(
                    user: user,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(user: user)));
                    },
                  );
                },
              );
            }

            return const Center(child: Text('Carregue os usuários'));
          },
        ),
      ),
    );
  }
}
