extension StringExtensions on String {
  String get formattedGender {
    if (toLowerCase() == 'male') return 'Masculino';
    if (toLowerCase() == 'female') return 'Feminino';
    return this;
  }

  String get formattedDate {
    try {
      final date = DateTime.parse(this);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return split('T')[0];
    }
  }
}
