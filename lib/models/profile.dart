import 'package:ehealth/models/account.dart';
import 'package:ehealth/models/basic_info/basic_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Profile {
  late Account user;
  late BasicInfo userDetail;

  Profile({
    required this.user,
    required this.userDetail
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return _$ProfileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
