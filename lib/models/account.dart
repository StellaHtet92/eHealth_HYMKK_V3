import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Account {
  late int userId;
  late String username;
  late String fullname;
  late String? mobile;
  late String dob;
  late String? gender;
  late String? password;
  late bool basicInfo;

  Account({
    this.userId = 0,
    this.fullname = "",
    this.username = "",
    this.dob = "",
    this.mobile = "",
    required this.gender,
    this.password = "",
    this.basicInfo = false,
  });

  Account.copy(Account acc) {
    userId = acc.userId;
    fullname = acc.fullname;
    username = acc.username;
    dob = acc.dob;
    mobile = acc.mobile;
    gender = acc.gender;
    password = acc.password;
    basicInfo = acc.basicInfo;
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return _$AccountFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
