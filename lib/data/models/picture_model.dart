import 'package:teste_bus2/domain/models/picture_entity.dart';

class PictureModel extends PictureEntity {
  PictureModel({required super.large, required super.medium, required super.thumbnail});

  factory PictureModel.fromMap(Map<String, dynamic> map) {
    return PictureModel(large: map['large'] ?? '', medium: map['medium'] ?? '', thumbnail: map['thumbnail'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'large': large, 'medium': medium, 'thumbnail': thumbnail};
  }
}
