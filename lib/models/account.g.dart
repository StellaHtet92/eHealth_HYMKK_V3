// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      userId: json['userId'] as int? ?? 0,
      fullname: json['fullname'] as String? ?? "",
      username: json['username'] as String? ?? "",
      dob: json['dob'] as String? ?? "",
      mobile: json['mobile'] as String? ?? "",
      gender: json['gender'] as String?,
      password: json['password'] as String? ?? "",
      basicInfo: json['basicInfo'] as bool? ?? false,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'fullname': instance.fullname,
      'mobile': instance.mobile,
      'dob': instance.dob,
      'gender': instance.gender,
      'password': instance.password,
      'basicInfo': instance.basicInfo,
    };
