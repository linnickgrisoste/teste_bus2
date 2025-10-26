import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:teste_bus2/data/services/setup/endpoint.dart';

typedef Failure = void Function(Exception error);
typedef Success = void Function(dynamic response);

class ApiProvider {
  late final Dio _dio;

  ApiProvider({Dio? dio}) {
    final options = BaseOptions(
      baseUrl: 'https://randomuser.me',
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 40),
    );

    _dio = dio ?? Dio(options);

    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true));
    }
  }

  Future<void> request({required Endpoint endpoint, required Success? success, required Failure? failure}) async {
    final contentType = endpoint.contentType ?? ContentType.json.value;

    final requestOptions = Options(
      method: endpoint.method,
      contentType: contentType,
      headers: {},
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    );

    try {
      final response = await _dio.request(
        endpoint.path,
        data: endpoint.data,
        options: requestOptions,
        queryParameters: endpoint.queryParameters,
      );
      success?.call(response.data);
    } on DioException catch (error) {
      failure?.call(error);
    }
  }
}
