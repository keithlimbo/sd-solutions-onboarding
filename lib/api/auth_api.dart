import 'package:dio/dio.dart';
import 'package:sdsolution_onboarding/bloc/auth_bloc.dart';
import 'package:sdsolution_onboarding/config/call_bloc.dart';
import 'package:sdsolution_onboarding/config/constants.dart';
import 'package:sdsolution_onboarding/service/shared_pref/user_shared_pref.dart';

class AuthRepository {
  late Dio dio;

  AuthRepository() {
    BaseOptions options = BaseOptions(
        baseUrl: ApiHelper.baseURL,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 5), // 60 seconds
        receiveTimeout: const Duration(seconds: 5) // 60 seconds
        );
    dio = Dio(options);
  }

  Future<String?> login(
      {required String username, required String password}) async {
    final response = await dio.post(ApiHelper.login,
        data: {"username": username, "password": password});
    return response.data;
  }

  Future<void> register(String adminBearerToken,
      {required String username,
      required String password,
      required String name,
      required String email}) async {
    await dio.post(ApiHelper.users,
        data: {
          "username": username,
          "password": password,
          "name": name,
          "email": email
        },
        options: Options(headers: {
          'Authorization': "Bearer $adminBearerToken",
          'Content-Type': "application/json"
        }));
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      String? userBearerToken = await UserStoredPref().getBearerToken();
      final response = await dio.get(ApiHelper.profile,
          options: Options(headers: {
            'Authorization': "Bearer $userBearerToken",
            'Content-Type': "application/json"
          }));
      return response.data;
    } catch (e) {
      authBloc.add(LogoutEvent());
    }
    return null;
  }

  Future<List?> getUsers() async {
    try {
      String? userBearerToken = await UserStoredPref().getBearerToken();
      final response = await dio.get(ApiHelper.users,
          options: Options(headers: {
            'Authorization': "Bearer $userBearerToken",
            'Content-Type': "application/json"
          }));
      return response.data as List?;
    } catch (e) {
      authBloc.add(LogoutEvent());
    }
    return [];
  }

  Future updateUser(
      {required int id,
      required String name,
      required bool isActive,
      required String email}) async {
    String? userBearerToken = await UserStoredPref().getBearerToken();
    await dio.put("${ApiHelper.users}/$id",
        data: {"name": name, "is_active": isActive, "email": email},
        options: Options(headers: {
          'Authorization': "Bearer $userBearerToken",
          'Content-Type': "application/json"
        }));
  }

  Future updateStatus(int id, bool isActive) async {
    String? userBearerToken = await UserStoredPref().getBearerToken();
    await dio.put("${ApiHelper.status}/$id",
        data: {
          "is_active": isActive,
        },
        options: Options(headers: {
          'Authorization': "Bearer $userBearerToken",
          'Content-Type': "application/json"
        }));
  }
}
