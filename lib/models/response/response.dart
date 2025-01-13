import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@Freezed(genericArgumentFactories: true)
class Response<T> with _$Response<T> {
  factory Response({
    String? message,
    T? data,
    Map<String, dynamic>? error,
  }) = _Response;

  factory Response.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$ResponseFromJson<T>(json, fromJsonT);
}
