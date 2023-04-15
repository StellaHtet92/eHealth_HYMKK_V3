import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/vital/vital.dart';
import 'package:ehealth/models/ecg/ecg.dart';
import 'package:ehealth/repository/model/error.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/dio_client.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/util/values/string.dart';
import 'package:ehealth/util/values/values.dart';

class EcgRepo {
  late DioClient dioClient;

  EcgRepo() {
    dioClient = DioClient(apiUrl);
  }

  Future<ApiResult<String>> saveEcg(Ecg ecg) async {
    print(ecg.toJson().toString());
    return UserPref().getAccount().then((acc) async {
      try {
        final response = await dioClient.post("/ecg/add?id=${acc?.userId}", data: ecg.toJson());
        ErrorModel responseModel = ErrorModel.fromJson(response);
        return ApiResult.success(responseModel.message);
      } catch (e) {
        return ApiResult.failure(NetworkExceptions.getDioException(e));
      }
    });
  }

  Future<ApiResult<String>> deleteEcg(int id) async {
    try {
      final response = await dioClient.get("/ecg/delete?id=$id");
      ErrorModel responseModel = ErrorModel.fromJson(response);
      return ApiResult.success(responseModel.message);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Ecg>>> fetchEcg(int pageNumber) async {
    return UserPref().getAccount().then((acc) async {
      try {
        Map<String, dynamic> data = {"userId": acc?.userId};
        final response = await dioClient.post("/ecg/list?pageNum=$pageNumber&pageSize=$pageSize", data: data);
        List<Ecg> list = List.from(response).map((e) => Ecg.fromJson(e)).toList();
        return ApiResult.success(list);
      } catch (e) {
        return ApiResult.failure(NetworkExceptions.getDioException(e));
      }
    });
  }
}
