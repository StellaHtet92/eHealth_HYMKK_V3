import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class ErrorModel {
  int code;
  String message;

  ErrorModel(this.code, this.message);

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return _$ErrorModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
