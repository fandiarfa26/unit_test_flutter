import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';
part 'auth.g.dart';

@freezed
class Auth with _$Auth {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Auth({
    String? accessToken,
    String? refreshToken,
    User? user,
  }) = _Auth;

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
}

@freezed
class User with _$User {
  factory User({
    String? id,
    String? email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
