// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse()
  ..error = json['error'] as String?
  ..success = json['success'] as bool?
  ..token = json['token'] as String?
  ..avatar = json['avatar'] as String?;

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'success': instance.success,
      'token': instance.token,
      'avatar': instance.avatar,
    };
