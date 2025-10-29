import 'package:teste_bus2/domain/models/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    required super.uuid,
    required super.username,
    required super.password,
    required super.salt,
    required super.md5,
    required super.sha1,
    required super.sha256,
  });

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      uuid: map['uuid'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      salt: map['salt'] ?? '',
      md5: map['md5'] ?? '',
      sha1: map['sha1'] ?? '',
      sha256: map['sha256'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
      'password': password,
      'salt': salt,
      'md5': md5,
      'sha1': sha1,
      'sha256': sha256,
    };
  }
}
