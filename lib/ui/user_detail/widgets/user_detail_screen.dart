import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teste_bus2/core/app_status.dart';
import 'package:teste_bus2/di/service_locator.dart';
import 'package:teste_bus2/domain/models/user_entity.dart';
import 'package:teste_bus2/ui/core/styles/app_colors.dart';
import 'package:teste_bus2/ui/core/styles/app_fonts.dart';
import 'package:teste_bus2/ui/core/ui/default_app_bar.dart';
import 'package:teste_bus2/ui/core/ui/default_cached_network_image.dart';
import 'package:teste_bus2/ui/core/ui/info_row.dart';
import 'package:teste_bus2/ui/core/ui/section_card.dart';
import 'package:teste_bus2/ui/user_detail/view_model/user_detail_cubit.dart';
import 'package:teste_bus2/ui/user_detail/view_model/user_detail_state.dart';
import 'package:teste_bus2/utils/extensions/string_extensions.dart';

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
                    content: Text('Usuário salvo com sucesso!', style: AppFonts.regular(14, AppColors.white)),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    duration: const Duration(seconds: 2),
                  )
                : SnackBar(
                    content: Text('Usuário removido com sucesso!', style: AppFonts.regular(14, AppColors.white)),
                    backgroundColor: AppColors.warning,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    duration: const Duration(seconds: 2),
                  ),
          );
        }

        if (state.status == AppStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro desconhecido', style: AppFonts.regular(14, AppColors.white)),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: DefaultAppBar(
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
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                    ),
                  );
                }

                return IconButton(
                  onPressed: () {
                    userDetailCubit.toggleUserPersistence(widget.user);
                  },
                  icon: Icon(state.isSaved ? Icons.favorite : Icons.favorite_border, color: AppColors.white),
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
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppColors.shadowMedium, blurRadius: 20, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: AppColors.white,
                        child: CircleAvatar(
                          radius: 66,
                          backgroundColor: AppColors.grey200,
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
                  InfoRow(label: 'Gênero:', value: widget.user.gender.formattedGender),
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
                  InfoRow(label: 'Data de Nascimento:', value: widget.user.dob.date.formattedDate),
                  InfoRow(label: 'Data de Registro:', value: widget.user.registered.date.formattedDate),
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
}
