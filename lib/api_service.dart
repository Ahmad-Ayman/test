import 'dart:async';
import 'dart:io';

import 'package:dash_shield/dash_shield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiServiceDio {
  static Dio dio = Dio();
  static ApiServiceDio? _instance;
  static SecurityContext? securityContext;

  static ApiServiceDio getInstance() {
    if (_instance == null) {
      BaseOptions options = BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 10),
      );
      dio.options = options;
      Future.wait([
        DashShield.applySSLPinning(
            ['assets/winlifenet.crt', 'assets/fakestoreapi.crt'], dio)
      ]);

      _instance = ApiServiceDio();
    }
    return _instance!;
  }

  Future<Response<dynamic>> get(String uri,
      {bool authorizedApi = false}) async {
    if (kDebugMode) {}
    var headers = {
      'Content-Type': 'application/json',
      'AgentType': Platform.isAndroid ? 2 : 1,
      'Authorization': authorizedApi
    };

    try {
      var res = await dio.get(
        uri,
        options: Options(
          headers: headers,
          responseType: ResponseType.plain,
        ),
      );

      return res;
    } on DioException catch (ex) {
      throw (ex.error.toString());
    }
  }

  Future<Response<dynamic>> post(
    String uri, {
    bool authorizedApi = false,
    String? body,
    FormData? formDataBody,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'AgentType': Platform.isAndroid ? 2 : 1,
      'Authorization': authorizedApi
    };
    if (kDebugMode) {}
    try {
      var data = body ?? formDataBody;
      var res = await dio.post(
        uri,
        data: data,
        options: Options(
          headers: headers,
          responseType: ResponseType.plain,
        ),
      );
      if (kDebugMode) {}

      return res;
    } on DioException catch (ex) {
      throw (ex.response?.data);
    }
  }
}

class ApiServiceHttp {
  static IOClient client = IOClient();
  static ApiServiceHttp? _instance;

  static ApiServiceHttp getInstance() {
    if (_instance == null) {
      // Initialize the HTTP client with SSL pinning

      Future.wait([
        applyssl(),
      ]);

      _instance = ApiServiceHttp();
    }
    return _instance!;
  }

  static Future<void> applyssl() async {
    client = await DashShield.applySSLPinning(
        ['assets/winlifenet.crt', 'assets/fakestoreapi.crt'], client);
  }

  Future<http.Response> get(String uri, {bool authorizedApi = false}) async {
    var headers = {
      'Content-Type': 'application/json',
      'AgentType': Platform.isAndroid ? '2' : '1',
      'Authorization': authorizedApi ? 'Bearer your_token' : '',
    };

    try {
      var response = await client.get(Uri.parse(uri), headers: headers);
      return response;
    } catch (e) {
      throw Exception("GET request error: $e");
    }
  }

  Future<http.Response> post(String uri,
      {bool authorizedApi = false, String? body}) async {
    var headers = {
      'Content-Type': 'application/json',
      'AgentType': Platform.isAndroid ? '2' : '1',
      'Authorization': authorizedApi ? 'Bearer your_token' : '',
    };

    try {
      var response = await client!.post(
        Uri.parse(uri),
        headers: headers,
        body: body,
      );
      return response;
    } catch (e) {
      throw Exception("POST request error: $e");
    }
  }
}
