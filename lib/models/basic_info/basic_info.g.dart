// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicInfo _$BasicInfoFromJson(Map<String, dynamic> json) => BasicInfo(
      bloodType: json['bloodType'] as String? ?? "",
      hcv: json['hcv'] as bool? ?? false,
      hcb: json['hcb'] as bool? ?? false,
      tb: json['tb'] as bool? ?? false,
      hiv: json['hiv'] as bool? ?? false,
      diabetes: json['diabetes'] as bool? ?? false,
      other: json['other'] as String? ?? "",
      allergies: json['allergies'] as String? ?? "",
      smokingStatus: json['smokingStatus'] as bool? ?? false,
      noOfCigaPerDay: json['noOfCigaPerDay'] as int? ?? 0,
    )
      ..weight = (json['weight'] as num?)?.toDouble()
      ..height = (json['height'] as num?)?.toDouble()
      ..bmi = (json['bmi'] as num?)?.toDouble();

Map<String, dynamic> _$BasicInfoToJson(BasicInfo instance) => <String, dynamic>{
      'bloodType': instance.bloodType,
      'hcv': instance.hcv,
      'hcb': instance.hcb,
      'tb': instance.tb,
      'hiv': instance.hiv,
      'diabetes': instance.diabetes,
      'other': instance.other,
      'allergies': instance.allergies,
      'weight': instance.weight,
      'height': instance.height,
      'bmi': instance.bmi,
      'smokingStatus': instance.smokingStatus,
      'noOfCigaPerDay': instance.noOfCigaPerDay,
    };
