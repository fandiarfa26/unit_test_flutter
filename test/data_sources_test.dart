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
      String email = 'admin@domain.com';
      String password = '!Password123';
      when(mockClient.post(Uri.parse('.../login'), body: {
        'email': email,
        'password': password,
      })).thenAnswer((_) async => Future.value(http.Response('''
      {
        "message": "Berhasil Login",
        "data": {
          "access_token": "ACCESS_TOKEN",
          "refresh_token": "REFRESH_TOKEN",
          "user": {
            "id": "id",
            "email": "admin@domain.com"
          }
        }
      }
      ''', 200)));

      final response = await dataSources.login(email: email, password: password);
      expect(
        response,
        equals(
          Response<Auth?>(
            message: 'Berhasil Login',
            data: Auth(
              accessToken: 'ACCESS_TOKEN',
              refreshToken: 'REFRESH_TOKEN',
              user: User(id: 'id', email: 'admin@domain.com'),
            ),
          ),
        ),
      );
    });

    test("400 - Input belum sesuai", () async {
      String email = '.com';
      String password = '!';
      when(mockClient.post(Uri.parse('.../login'), body: {
        'email': email,
        'password': password,
      })).thenAnswer((_) async => Future.value(http.Response('''
      {
        "message": "Input belum sesuai",
        "error": {
          "email": "Email belum valid",
          "password": "Password belum valid"
        }
      }
      ''', 400)));

      final response = await dataSources.login(email: email, password: password);
      expect(
        response,
        equals(
          Response<Auth?>(
            message: 'Input belum sesuai',
            error: {
              'email': 'Email belum valid',
              'password': 'Password belum valid',
            },
          ),
        ),
      );
    });

    test("404 - Not Found", () async {
      String email = 'admin@domain';
      String password = '!asa';
      when(mockClient.post(Uri.parse('.../login'), body: {
        'email': email,
        'password': password,
      })).thenAnswer((_) async => Future.value(http.Response('''
      {
        "message": "Not Found"
      }
      ''', 404)));

      final response = await dataSources.login(email: email, password: password);
      expect(
        response,
        equals(
          Response<Auth?>(
            message: 'Not Found',
          ),
        ),
      );
    });

    test("500 - Server Error", () async {
      String email = 'admin@';
      String password = '!asa';
      when(mockClient.post(Uri.parse('.../login'), body: {
        'email': email,
        'password': password,
      })).thenAnswer((_) async => Future.value(http.Response('''
      {
        "message": "Server Error"
      }
      ''', 500)));

      final response = await dataSources.login(email: email, password: password);
      expect(
        response,
        equals(
          Response<Auth?>(
            message: 'Server Error',
          ),
        ),
      );
    });
  });

  group('Test Case Get Products', () {
    test('200 - Get Products Berhasil', () async {
      when(mockClient.get(Uri.parse('.../products'))).thenAnswer((_) async => Future.value(http.Response('''
      {
        "message": "Berhasil Get Products",
        "data": [
          {
            "name": "nama product",
            "qty": 1,
            "price": 10000
          }
        ]
      }
      ''', 200)));

      final response = await dataSources.getProducts();
      expect(
        response,
        equals(Response<List<Product>>(
          message: 'Berhasil Get Products',
          data: [
            Product(name: 'nama product', qty: 1, price: 10000),
          ],
        )),
      );
    });

    test('400 - Get Products Failed', () async {
      when(mockClient.get(Uri.parse('.../products'))).thenAnswer((_) async => Future.value(http.Response('''
      {
        "message": "Get Products Failed"
      }
      ''', 400)));

      final response = await dataSources.getProducts();
      expect(
        response,
        equals(Response<List<Product>>(
          message: 'Get Products Failed',
        )),
      );
    });

    test('404 - Get Products Not Found', () async {
      when(mockClient.get(Uri.parse('.../products'))).thenAnswer((_) async => Future.value(http.Response('''
      {
        "message": "Get Products Not Found"
      }
      ''', 404)));

      final response = await dataSources.getProducts();
      expect(
        response,
        equals(Response<List<Product>>(
          message: 'Get Products Not Found',
        )),
      );
    });

    test('500 - Get Products Server Error', () async {
      when(mockClient.get(Uri.parse('.../products'))).thenAnswer((_) async => Future.value(http.Response('''
      {
        "message": "Get Products Server Error"
      }
      ''', 500)));

      final response = await dataSources.getProducts();
      expect(
        response,
        equals(Response<List<Product>>(
          message: 'Get Products Server Error',
        )),
      );
    });
  });
}
