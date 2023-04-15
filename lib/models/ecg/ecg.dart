import 'package:json_annotation/json_annotation.dart';

part 'ecg.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Ecg {
  late int id;
  late int userid;
  late String ecg;
  late String ecgResults;

  Ecg({
    this.id = 0,
    this.userid = 0,
    this.ecg = "",
    this.ecgResults = ""
  });

  Ecg.copy(Ecg Ecg) {
    id = Ecg.id;
    userid = Ecg.userid;
    ecg = Ecg.ecg;
    ecgResults = Ecg.ecgResults;
  }

  factory Ecg.fromJson(Map<String, dynamic> json) {
    return _$EcgFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EcgToJson(this);
}
