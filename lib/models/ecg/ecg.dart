import 'package:json_annotation/json_annotation.dart';

part 'ecg.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Ecg {
  late int id;
  late int userid;
  late String ecg;
  late String ecgResults;
  late List<int> ecgData;

  Ecg({
    this.id = 0,
    this.userid = 0,
    this.ecg = "",
    this.ecgResults = "",
    this.ecgData = const []
  });

  Ecg.copy(Ecg Ecg) {
    id = Ecg.id;
    userid = Ecg.userid;
    ecg = Ecg.ecg;
    ecgResults = Ecg.ecgResults;
    ecgData = Ecg.ecgData;
  }

  factory Ecg.fromJson(Map<String, dynamic> json) {
    return _$EcgFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EcgToJson(this);
}
