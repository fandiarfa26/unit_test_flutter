import 'dart:convert';

import 'package:unit_test_flutter/models/auth/auth.dart';
import 'package:unit_test_flutter/models/product/product.dart';
import 'package:unit_test_flutter/models/response/response.dart';
import 'package:http/http.dart' as http;

class DataSources {
  final http.Client client;

  DataSources(this.client);

  Future<Response<Auth?>> login({required String email, required String password}) async {
    String url = '.../login';

    final response = await client.post(
      Uri.parse(url),
      body: {
        'email': email,
        'password': password, // ini yg benar
        // 'passwords': password, // ini yg salah
      },
    );

    return Response.fromJson(
      jsonDecode(response.body),
      (json) => Auth.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Response<List<Product>>> getProducts() async {
    String url = '.../products';

    final response = await client.get(Uri.parse(url));

    return Response<List<Product>>.fromJson(
      jsonDecode(response.body),
      (json) => (json as List).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
