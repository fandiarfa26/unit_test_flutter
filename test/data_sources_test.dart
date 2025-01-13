import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:unit_test_flutter/data_sources.dart';
import 'package:unit_test_flutter/models/auth/auth.dart';
import 'package:unit_test_flutter/models/product/product.dart';
import 'package:unit_test_flutter/models/response/response.dart';

import 'data_sources_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late DataSources dataSources;

  setUp(() {
    mockClient = MockClient();
    dataSources = DataSources(mockClient);
  });

  group('Test Case Login', () {
    test('200 - Login Berhasil', () async {
      final email = 'admin@domain.com';
      final password = '!Password123';

      final uri = Uri.parse('.../login');
      final body = {
        'email': email,
        'password': password,
      };
      final responseFile = File('json/login/login_200_response.json');
      final mockResponse = await responseFile.readAsString();
      final expectedResponse = Response<Auth?>(
        message: 'Berhasil Login',
        data: Auth(
          accessToken: 'ACCESS_TOKEN',
          refreshToken: 'REFRESH_TOKEN',
          user: User(id: 'id', email: 'admin@domain.com'),
        ),
      );

      when(mockClient.post(uri, body: body)).thenAnswer((_) async => Future.value(http.Response(mockResponse, 200)));

      final response = await dataSources.login(email: email, password: password);
      expect(response, equals(expectedResponse));
      verify(mockClient.post(uri, body: body)).called(1);
    });

    test("400 - Input belum sesuai", () async {
      String email = '.com';
      String password = '!';

      final uri = Uri.parse('.../login');
      final body = {
        'email': email,
        'password': password,
      };
      final responseFile = File('json/login/login_400_response.json');
      final mockResponse = await responseFile.readAsString();
      final expectedResponse = Response<Auth?>(
        message: 'Input belum sesuai',
        error: {
          'email': 'Email belum valid',
          'password': 'Password belum valid',
        },
      );

      when(mockClient.post(uri, body: body)).thenAnswer((_) async => Future.value(http.Response(mockResponse, 400)));

      final response = await dataSources.login(email: email, password: password);
      expect(response, equals(expectedResponse));
      verify(mockClient.post(uri, body: body)).called(1);
    });

    test("404 - Not Found", () async {
      String email = 'admin@domain';
      String password = '!asa';

      final uri = Uri.parse('.../login');
      final body = {
        'email': email,
        'password': password,
      };
      final responseFile = File('json/login/login_404_response.json');
      final mockResponse = await responseFile.readAsString();
      final expectedResponse = Response<Auth?>(
        message: 'Not Found',
      );

      when(mockClient.post(uri, body: body)).thenAnswer((_) async => Future.value(http.Response(mockResponse, 404)));

      final response = await dataSources.login(email: email, password: password);
      expect(response, equals(expectedResponse));
      verify(mockClient.post(uri, body: body)).called(1);
    });

    test("500 - Server Error", () async {
      String email = 'admin@';
      String password = '!asa';

      final uri = Uri.parse('.../login');
      final body = {
        'email': email,
        'password': password,
      };
      final responseFile = File('json/login/login_500_response.json');
      final mockResponse = await responseFile.readAsString();
      final expectedResponse = Response<Auth?>(
        message: 'Server Error',
      );

      when(mockClient.post(uri, body: body)).thenAnswer((_) async => Future.value(http.Response(mockResponse, 500)));

      final response = await dataSources.login(email: email, password: password);
      expect(response, equals(expectedResponse));
      verify(mockClient.post(uri, body: body)).called(1);
    });
  });

  group('Test Case Get Products', () {
    test('200 - Get Products Berhasil', () async {
      final uri = Uri.parse('.../products');
      final responseFile = File('json/product/product_200_response.json');
      final mockResponse = await responseFile.readAsString();
      final expectedResponse = Response<List<Product>>(
        message: 'Berhasil Get Products',
        data: [
          Product(name: 'nama product', qty: 1, price: 10000),
        ],
      );

      when(mockClient.get(uri)).thenAnswer((_) async => Future.value(http.Response(mockResponse, 200)));

      final response = await dataSources.getProducts();
      expect(response, equals(expectedResponse));
      verify(mockClient.get(uri)).called(1);
    });

    test('400 - Get Products Failed', () async {
      final uri = Uri.parse('.../products');
      final responseFile = File('json/product/product_400_response.json');
      final mockResponse = await responseFile.readAsString();
      final expectedResponse = Response<List<Product>>(
        message: 'Get Products Failed',
      );

      when(mockClient.get(uri)).thenAnswer((_) async => Future.value(http.Response(mockResponse, 400)));

      final response = await dataSources.getProducts();
      expect(response, equals(expectedResponse));
      verify(mockClient.get(uri)).called(1);
    });

    test('404 - Get Products Not Found', () async {
      final uri = Uri.parse('.../products');
      final responseFile = File('json/product/product_404_response.json');
      final mockResponse = await responseFile.readAsString();
      final expectedResponse = Response<List<Product>>(
        message: 'Get Products Not Found',
      );

      when(mockClient.get(uri)).thenAnswer((_) async => Future.value(http.Response(mockResponse, 404)));

      final response = await dataSources.getProducts();
      expect(response, equals(expectedResponse));
      verify(mockClient.get(uri)).called(1);
    });

    test('500 - Get Products Server Error', () async {
      final uri = Uri.parse('.../products');
      final responseFile = File('json/product/product_500_response.json');
      final mockResponse = await responseFile.readAsString();
      final expectedResponse = Response<List<Product>>(
        message: 'Get Products Server Error',
      );

      when(mockClient.get(uri)).thenAnswer((_) async => Future.value(http.Response(mockResponse, 500)));

      final response = await dataSources.getProducts();
      expect(response, equals(expectedResponse));
      verify(mockClient.get(uri)).called(1);
    });
  });
}
