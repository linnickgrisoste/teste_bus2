extension StringExtensions on String {
  /// Formata o gênero de inglês para português
  String get formattedGender {
    if (toLowerCase() == 'male') return 'Masculino';
    if (toLowerCase() == 'female') return 'Feminino';
    return this;
  }

  /// Formata uma data string no formato ISO para DD/MM/YYYY
  String get formattedDate {
    try {
      final date = DateTime.parse(this);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return split('T')[0];
    }
  }
}
