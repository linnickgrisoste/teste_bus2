import 'package:flutter/material.dart';
import 'package:teste_bus2/models/user.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.name.first} ${user.name.last}'),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
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
                    backgroundImage: NetworkImage(user.picture.large),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${user.name.title} ${user.name.first} ${user.name.last}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text('${user.dob.age} anos', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Informações de contato
            _buildSection(
              title: 'Contato',
              items: [
                _buildInfoRow(Icons.email, 'Email', user.email),
                _buildInfoRow(Icons.phone, 'Telefone', user.phone),
                _buildInfoRow(Icons.phone_android, 'Celular', user.cell),
              ],
            ),
            const SizedBox(height: 8),
            // Localização
            _buildSection(
              title: 'Localização',
              items: [
                _buildInfoRow(
                  Icons.location_on,
                  'Endereço',
                  '${user.location.street.name}, ${user.location.street.number}',
                ),
                _buildInfoRow(Icons.location_city, 'Cidade', user.location.city),
                _buildInfoRow(Icons.map, 'Estado', user.location.state),
                _buildInfoRow(Icons.public, 'País', user.location.country),
                _buildInfoRow(Icons.markunread_mailbox, 'CEP', user.location.postcode),
              ],
            ),
            const SizedBox(height: 8),
            // Outras informações
            _buildSection(
              title: 'Outras Informações',
              items: [
                _buildInfoRow(Icons.person, 'Gênero', user.gender),
                _buildInfoRow(Icons.flag, 'Nacionalidade', user.nat),
                _buildInfoRow(Icons.cake, 'Data de Nascimento', user.dob.date.split('T')[0]),
                _buildInfoRow(Icons.calendar_today, 'Registrado em', user.registered.date.split('T')[0]),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
