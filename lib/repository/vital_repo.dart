import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/repository/model/error.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/dio_client.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/util/values/string.dart';

class VitalRepo {
  late DioClient dioClient;

  VitalRepo() {
    dioClient = DioClient(apiUrl);
  }

  Future<ApiResult<String>> saveVital(Vital v) async {
    return UserPref().getAccount().then((acc) async {
      try {
        final response = await dioClient.post("/vital/add?id=${acc?.userId}", data: v.toJson());
        ErrorModel responseModel = ErrorModel.fromJson(response);
        return ApiResult.success(responseModel.message);
      } catch (e) {
        return ApiResult.failure(NetworkExceptions.getDioException(e));
      }
    });
  }
}
