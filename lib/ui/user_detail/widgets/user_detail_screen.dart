import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/di/service_locator.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';
import 'package:teste_bus2/ui/core/ui/default_cached_network_image.dart';
import 'package:teste_bus2/ui/core/ui/info_row.dart';
import 'package:teste_bus2/ui/core/ui/section_card.dart';
import 'package:teste_bus2/ui/core/ui/themed_app_bar.dart';
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
                ? SnackBar(
                    content: const Text('Usuário salvo com sucesso!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    duration: const Duration(seconds: 2),
                  )
                : SnackBar(
                    content: const Text('Usuário removido com sucesso!'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    duration: const Duration(seconds: 2),
                  ),
          );
        }

        if (state.status == AppStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro desconhecido'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: ThemedAppBar(
          title: '${widget.user.name.first} ${widget.user.name.last}',
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
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    ),
                  );
                }

                return IconButton(
                  onPressed: () {
                    userDetailCubit.toggleUserPersistence(widget.user);
                  },
                  icon: Icon(state.isSaved ? Icons.favorite : Icons.favorite_border, color: Colors.white),
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
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5E72E4), Color(0xFF825EE4)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 66,
                          backgroundColor: Colors.grey[300],
                          child: DefaultCachedNetworkImage(imageUrl: widget.user.picture.large, size: 132),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Informações Pessoais
              SectionCard(
                title: 'Informações Pessoais',
                icon: Icons.person_outline,
                children: [
                  InfoRow(
                    label: 'Nome Completo:',
                    value: '${widget.user.name.title} ${widget.user.name.first} ${widget.user.name.last}',
                  ),
                  InfoRow(label: 'Idade:', value: '${widget.user.dob.age} anos'),
                  InfoRow(label: 'Gênero:', value: _formatGender(widget.user.gender)),
                ],
              ),
              // Localização
              SectionCard(
                title: 'Localização',
                icon: Icons.location_on_outlined,
                children: [
                  InfoRow(label: 'País:', value: widget.user.location.country),
                  InfoRow(label: 'Estado:', value: widget.user.location.state),
                  InfoRow(label: 'Cidade:', value: widget.user.location.city),
                  InfoRow(
                    label: 'Rua:',
                    value: '${widget.user.location.street.name}, ${widget.user.location.street.number}',
                  ),
                  InfoRow(label: 'CEP:', value: widget.user.location.postcode),
                  InfoRow(
                    label: 'Coordenadas:',
                    value:
                        '${widget.user.location.coordinates.latitude}, ${widget.user.location.coordinates.longitude}',
                  ),
                  InfoRow(
                    label: 'Fuso Horário:',
                    value: '${widget.user.location.timezone.offset} - ${widget.user.location.timezone.description}',
                  ),
                ],
              ),
              // Contato
              SectionCard(
                title: 'Contato',
                icon: Icons.contact_mail_outlined,
                children: [
                  InfoRow(label: 'Email:', value: widget.user.email),
                  InfoRow(label: 'Telefone:', value: widget.user.phone),
                  InfoRow(label: 'Celular:', value: widget.user.cell),
                ],
              ),
              // Login
              SectionCard(
                title: 'Login',
                icon: Icons.lock_outline,
                children: [
                  InfoRow(label: 'UUID:', value: widget.user.login.uuid),
                  InfoRow(label: 'Username:', value: widget.user.login.username),
                  InfoRow(label: 'Password:', value: widget.user.login.password),
                  InfoRow(label: 'Salt:', value: widget.user.login.salt),
                  InfoRow(label: 'MD5:', value: widget.user.login.md5),
                  InfoRow(label: 'SHA1:', value: widget.user.login.sha1),
                  InfoRow(label: 'SHA256:', value: widget.user.login.sha256),
                ],
              ),
              // Documentos
              if (widget.user.id.name.isNotEmpty && widget.user.id.value.isNotEmpty)
                SectionCard(
                  title: 'Documentos',
                  icon: Icons.badge_outlined,
                  children: [InfoRow(label: '${widget.user.id.name}:', value: widget.user.id.value)],
                ),
              // Datas
              SectionCard(
                title: 'Datas',
                icon: Icons.calendar_today_outlined,
                children: [
                  InfoRow(label: 'Data de Nascimento:', value: _formatDate(widget.user.dob.date)),
                  InfoRow(label: 'Data de Registro:', value: _formatDate(widget.user.registered.date)),
                  InfoRow(label: 'Tempo de Registro:', value: '${widget.user.registered.age} anos'),
                ],
              ),
              // Outras Informações
              SectionCard(
                title: 'Outras Informações',
                icon: Icons.info_outline,
                children: [InfoRow(label: 'Nacionalidade:', value: widget.user.nat)],
              ),
              const SizedBox(height: 32),
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
}
