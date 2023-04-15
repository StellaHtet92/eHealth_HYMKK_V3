// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ecg _$EcgFromJson(Map<String, dynamic> json) => Ecg(
      id: json['id'] as int? ?? 0,
      userid: json['userid'] as int? ?? 0,
      ecg: json['ecg'] as String? ?? "",
      ecgResults: json['ecgResults'] as String? ?? "",
    );

Map<String, dynamic> _$EcgToJson(Ecg instance) => <String, dynamic>{
      'id': instance.id,
      'userid': instance.userid,
      'ecg': instance.ecg,
      'ecgResults': instance.ecgResults,
    };
