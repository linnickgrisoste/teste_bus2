import 'package:teste_bus2/models/name_entity.dart';

class NameModel extends NameEntity {
  NameModel({required super.title, required super.first, required super.last});

  factory NameModel.fromMap(Map<String, dynamic> map) {
    return NameModel(title: map['title'] ?? '', first: map['first'] ?? '', last: map['last'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'first': first, 'last': last};
  }
}
