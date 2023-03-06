import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/repository/model/error.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/dio_client.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';

class VitalRepo {
  late DioClient dioClient;

  VitalRepo() {
    dioClient = DioClient(apiUrl);
  }

  Future<ApiResult<String>> saveVital(Vital v) async {
    print(v.toJson().toString());
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

  Future<ApiResult<String>> deleteVital(int id) async {
    try {
      final response = await dioClient.get("/vital/delete?id=$id");
      ErrorModel responseModel = ErrorModel.fromJson(response);
      return ApiResult.success(responseModel.message);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Vital>>> fetchVital(int pageNumber) async {
    return UserPref().getAccount().then((acc) async {
      try {
        Map<String, dynamic> data = {"userId": acc?.userId};
        final response = await dioClient.post("/vital/list?pageNum=$pageNumber&pageSize=$pageSize", data: data);
        List<Vital> list = List.from(response).map((e) => Vital.fromJson(e)).toList();
        return ApiResult.success(list);
      } catch (e) {
        return ApiResult.failure(NetworkExceptions.getDioException(e));
      }
    });
  }
}
