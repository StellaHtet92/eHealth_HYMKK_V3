import 'package:ehealth/core/user_pref.dart';
import 'package:ehealth/models/account.dart';
import 'package:ehealth/models/basic_info/basic_info.dart';
import 'package:ehealth/models/profile.dart';
import 'package:ehealth/repository/model/error.dart';
import 'package:ehealth/repository/services/api_result.dart';
import 'package:ehealth/repository/services/dio_client.dart';
import 'package:ehealth/repository/services/network_exceptions.dart';
import 'package:ehealth/util/values/string.dart';


class AccountRepo{
  late DioClient dioClient;

  AccountRepo() {
    dioClient = DioClient(apiUrl);
  }

  Future<ApiResult<Account>> login(String userName,String password) async {
    try {
      Map<String, dynamic> data = {"username": userName, "password": password};
      final response = await dioClient.post("/user/login", data: data);
      Account account = Account.fromJson(response);
      return ApiResult.success(account);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Account>> register(Account userAcc) async {
    print(userAcc.toJson());
    try {
      final response = await dioClient.post("/user/register", data: userAcc.toJson());
      Account account = Account.fromJson(response);
      return ApiResult.success(account);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<String>> saveBasicInfo(BasicInfo info) async {
    return UserPref().getAccount().then((acc) async {
      try {
        final response = await dioClient.post("/user/info/basic?id=${acc?.userId}", data: info.toJson());
        ErrorModel responseModel = ErrorModel.fromJson(response);
        return ApiResult.success(responseModel.message);
      } catch (e) {
        return ApiResult.failure(NetworkExceptions.getDioException(e));
      }
    });
  }

  Future<ApiResult<Profile>> getUserDetail(int userId) async {
    try {
      final response = await dioClient.get("/user/getUserDetail?id=$userId");
      Profile profile = Profile.fromJson(response);
      return ApiResult.success(profile);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

}