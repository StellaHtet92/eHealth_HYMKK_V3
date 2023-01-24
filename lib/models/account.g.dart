// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      userId: json['userId'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? "",
      userName: json['userName'] as String? ?? "",
      dob: json['dob'] as String? ?? "",
      mobile: json['mobile'] as String? ?? "",
      gender: json['gender'] as String?,
      password: json['password'] as String? ?? "",
      basicInfo: json['basicInfo'] as bool? ?? false,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'fullName': instance.fullName,
      'mobile': instance.mobile,
      'dob': instance.dob,
      'gender': instance.gender,
      'password': instance.password,
      'basicInfo': instance.basicInfo,
    };
