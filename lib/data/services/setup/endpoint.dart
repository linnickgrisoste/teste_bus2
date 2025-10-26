class Endpoint {
  String path;
  dynamic data;
  String method;
  String? contentType;
  Map<String, dynamic>? queryParameters;

  Endpoint({required this.path, required this.method, this.data, this.contentType, this.queryParameters});
}
