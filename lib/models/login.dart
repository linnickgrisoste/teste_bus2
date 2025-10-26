class Login {
  final String uuid;
  final String username;
  final String password;
  final String salt;
  final String md5;
  final String sha1;
  final String sha256;

  Login({
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
  });

  Login.fromMap(Map<String, dynamic> map)
    : uuid = map['uuid'] ?? '',
      username = map['username'] ?? '',
      password = map['password'] ?? '',
      salt = map['salt'] ?? '',
      md5 = map['md5'] ?? '',
      sha1 = map['sha1'] ?? '',
      sha256 = map['sha256'] ?? '';

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
