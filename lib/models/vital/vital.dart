import 'package:json_annotation/json_annotation.dart';

part 'vital.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Vital {
  late int id;
  late int bpSys;
  late int bpDia;
  late int pulse;
  late double temp;
  late double spO2;
  late double resp_rate;
  late double bloodSugarLevel;
  late bool isBeforeMeal;
  late int hdl;
  late int ldl;
  late int heartRate;
  late int ews;
  late int alert;
  late String lastMenDate;
  late String createdDateTime;

  Vital({
    this.id = 0,
    this.bpSys = 0,
    this.bpDia = 0,
    this.pulse = 0,
    this.temp = 0.0,
    this.spO2 = 0.0,
    this.resp_rate=0.0,
    this.bloodSugarLevel = 0.0,
    this.isBeforeMeal = false,
    this.hdl = 0,
    this.ldl = 0,
    this.heartRate = 0,
    this.ews = 0,
    this.alert=0,
    this.lastMenDate= "",
    this.createdDateTime = ""
  });

  Vital.copy(Vital vital) {
    id = vital.id;
    bpSys = vital.bpSys;
    bpDia = vital.bpDia;
    pulse = vital.pulse;
    temp = vital.temp;
    spO2 = vital.spO2;
    resp_rate=vital.resp_rate;
    bloodSugarLevel = bloodSugarLevel;
    isBeforeMeal = vital.isBeforeMeal;
    hdl = vital.hdl;
    ldl = vital.ldl;
    heartRate = vital.heartRate;
    ews=vital.ews;
    alert=vital.alert;
    lastMenDate = vital.lastMenDate;
    createdDateTime = vital.createdDateTime;
  }

  factory Vital.fromJson(Map<String, dynamic> json) {
    return _$VitalFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VitalToJson(this);
}
