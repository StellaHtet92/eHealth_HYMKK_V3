// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vital.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vital _$VitalFromJson(Map<String, dynamic> json) => Vital(
      bpSys: json['bpSys'] as int? ?? 0,
      bpDia: json['bpDia'] as int? ?? 0,
      pulse: json['pulse'] as int? ?? 0,
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      spO2: (json['spO2'] as num?)?.toDouble() ?? 0.0,
      bloodSugarLevel: (json['bloodSugarLevel'] as num?)?.toDouble() ?? 0.0,
      isBeforeMeal: json['isBeforeMeal'] as bool? ?? false,
    );

Map<String, dynamic> _$VitalToJson(Vital instance) => <String, dynamic>{
      'bpSys': instance.bpSys,
      'bpDia': instance.bpDia,
      'pulse': instance.pulse,
      'temp': instance.temp,
      'spO2': instance.spO2,
      'bloodSugarLevel': instance.bloodSugarLevel,
      'isBeforeMeal': instance.isBeforeMeal,
    };
