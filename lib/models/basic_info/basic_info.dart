import 'package:json_annotation/json_annotation.dart';

part 'basic_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class BasicInfo {
  late String bloodType;
  late bool hcv;
  late bool hcb;
  late bool tb;
  late bool hiv;
  late bool diabetes;
  late String? other;
  late String allergies;
  double? weight;
  double? height;
  double? bmi;
  late bool smokingStatus;
  late int? noOfCigaPerDay;

  BasicInfo({
    this.bloodType = "",
    this.hcv = false,
    this.hcb = false,
    this.tb = false,
    this.hiv = false,
    this.diabetes = false,
    this.other = "",
    this.allergies = "",
    this.smokingStatus = false,
    this.noOfCigaPerDay = 0,
  });

  BasicInfo.copy(BasicInfo info) {
    bloodType = info.bloodType;
    hcv = info.hcv;
    hcb = info.hcb;
    tb = info.tb;
    hiv = info.hiv;
    diabetes = info.diabetes;
    other = info.other;
    weight = info.weight;
    height = info.height;
    bmi = info.bmi;
    allergies = info.allergies;
    smokingStatus = info.smokingStatus;
    noOfCigaPerDay = info.noOfCigaPerDay;
  }

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return _$BasicInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BasicInfoToJson(this);
}
