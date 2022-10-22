import 'package:dio/dio.dart';
import 'package:shop_app_udgrade/shop/shared/network/api_const.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstance.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData(
      {required String url,
      Map<String, dynamic>? query,
      String lang = 'en',
      String? token}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };

    return await dio.get(url, queryParameters: query);
  }

// post data // login and register and favorites

  static Future<Response> postData(
      {required String url,
      Map<String, dynamic>? query,
      required Map<String, dynamic> data,
      String lang = 'ar',
      String? token}) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
    };

    return await dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

//update data

  static Future<Response> putData(
      {required String url,
      Map<String, dynamic>? query,
      required Map<String, dynamic> data,
      String lang = 'ar',
      String? token}) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
    };

    return await dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
