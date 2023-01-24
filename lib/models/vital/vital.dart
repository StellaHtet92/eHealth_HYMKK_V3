import 'package:json_annotation/json_annotation.dart';

part 'vital.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Vital {
  late int bpSys;
  late int bpDia;
  late int pulse;
  late double temp;
  late double spO2;
  late double bloodSugarLevel;
  late bool isBeforeMeal;

  Vital({
    this.bpSys = 0,
    this.bpDia = 0,
    this.pulse = 0,
    this.temp = 0.0,
    this.spO2 = 0.0,
    this.bloodSugarLevel = 0.0,
    this.isBeforeMeal = false,
  });

  Vital.copy(Vital vital) {
    bpSys = vital.bpSys;
    bpDia = vital.bpDia;
    pulse = vital.pulse;
    temp = vital.temp;
    spO2 = vital.spO2;
    bloodSugarLevel = bloodSugarLevel;
    isBeforeMeal = vital.isBeforeMeal;
  }

  factory Vital.fromJson(Map<String, dynamic> json) {
    return _$VitalFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VitalToJson(this);
}
