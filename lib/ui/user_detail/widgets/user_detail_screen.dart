import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/di/service_locator.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';
import 'package:teste_bus2/ui/core/ui/default_cached_network_image.dart';
import 'package:teste_bus2/ui/user_detail/view_model/user_detail_cubit.dart';
import 'package:teste_bus2/ui/user_detail/view_model/user_detail_state.dart';

class UserDetailScreen extends StatefulWidget {
  final UserEntity user;

  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late final UserDetailCubit userDetailCubit;

  @override
  void initState() {
    super.initState();
    userDetailCubit = ServiceLocator.get<UserDetailCubit>();
    userDetailCubit.checkIfUserIsSaved(widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDetailCubit, UserDetailState>(
      bloc: userDetailCubit,
      listener: (context, state) {
        if (state.status == AppStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            state.isSaved
                ? const SnackBar(
                    content: Text('Usuário salvo com sucesso!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  )
                : const SnackBar(
                    content: Text('Usuário removido com sucesso!'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
          );
        }

        if (state.status == AppStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro desconhecido'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.user.name.first} ${widget.user.name.last}'),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black,
          actions: [
            BlocBuilder<UserDetailCubit, UserDetailState>(
              bloc: userDetailCubit,
              builder: (context, state) {
                if (state.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                    ),
                  );
                }

                return IconButton(
                  onPressed: () {
                    userDetailCubit.toggleUserPersistence(widget.user);
                  },
                  icon: Icon(
                    state.isSaved ? Icons.favorite : Icons.favorite_border,
                    color: state.isSaved ? Colors.red : Colors.grey,
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header com foto
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: DefaultCachedNetworkImage(imageUrl: widget.user.picture.large, size: 120),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Informações Pessoais
              _buildSection(
                title: 'Informações Pessoais',
                items: [
                  _buildInfoRow(
                    'Nome Completo:',
                    '${widget.user.name.title} ${widget.user.name.first} ${widget.user.name.last}',
                  ),
                  _buildInfoRow('Idade:', '${widget.user.dob.age} anos'),
                  _buildInfoRow('Gênero:', _formatGender(widget.user.gender)),
                ],
              ),
              const SizedBox(height: 8),
              // Localização
              _buildSection(
                title: 'Localização',
                items: [
                  _buildInfoRow('País:', widget.user.location.country),
                  _buildInfoRow('Estado:', widget.user.location.state),
                  _buildInfoRow('Cidade:', widget.user.location.city),
                  _buildInfoRow('Rua:', '${widget.user.location.street.name}, ${widget.user.location.street.number}'),
                  _buildInfoRow('CEP:', widget.user.location.postcode),
                  _buildInfoRow(
                    'Coordenadas:',
                    '${widget.user.location.coordinates.latitude}, ${widget.user.location.coordinates.longitude}',
                  ),
                  _buildInfoRow(
                    'Fuso Horário:',
                    '${widget.user.location.timezone.offset} - ${widget.user.location.timezone.description}',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Contato
              _buildSection(
                title: 'Contato',
                items: [
                  _buildInfoRow('Email:', widget.user.email),
                  _buildInfoRow('Telefone:', widget.user.phone),
                  _buildInfoRow('Celular:', widget.user.cell),
                ],
              ),
              const SizedBox(height: 8),
              // Login
              _buildSection(
                title: 'Login',
                items: [
                  _buildInfoRow('UUID:', widget.user.login.uuid),
                  _buildInfoRow('Username:', widget.user.login.username),
                  _buildInfoRow('Password:', widget.user.login.password),
                  _buildInfoRow('Salt:', widget.user.login.salt),
                  _buildInfoRow('MD5:', widget.user.login.md5),
                  _buildInfoRow('SHA1:', widget.user.login.sha1),
                  _buildInfoRow('SHA256:', widget.user.login.sha256),
                ],
              ),
              const SizedBox(height: 8),
              // Documentos
              if (widget.user.id.name.isNotEmpty && widget.user.id.value.isNotEmpty)
                _buildSection(
                  title: 'Documentos',
                  items: [_buildInfoRow('${widget.user.id.name}:', widget.user.id.value)],
                ),
              if (widget.user.id.name.isNotEmpty && widget.user.id.value.isNotEmpty) const SizedBox(height: 8),
              // Datas
              _buildSection(
                title: 'Datas',
                items: [
                  _buildInfoRow('Data de Nascimento:', _formatDate(widget.user.dob.date)),
                  _buildInfoRow('Data de Registro:', _formatDate(widget.user.registered.date)),
                  _buildInfoRow('Tempo de Registro:', '${widget.user.registered.age} anos'),
                ],
              ),
              const SizedBox(height: 8),
              // Outras Informações
              _buildSection(title: 'Outras Informações', items: [_buildInfoRow('Nacionalidade:', widget.user.nat)]),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _formatGender(String gender) {
    if (gender.toLowerCase() == 'male') return 'Masculino';
    if (gender.toLowerCase() == 'female') return 'Feminino';
    return gender;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString.split('T')[0];
    }
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const Divider(height: 24, thickness: 1),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
