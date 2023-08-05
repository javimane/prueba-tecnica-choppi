import 'package:dio/dio.dart';


import '../../../../config/config.dart';

import '../../datasource/info_datasource.dart';

import '../../entities/info.dart';




class InfoDatasourceImpl extends InfoDatasource {

  late final Dio dio;
  final String accessToken;

  InfoDatasourceImpl({
    required this.accessToken
  }) : dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
     
    )
  );

  

  
  @override
  Future<List<Map<String, dynamic>>> getInfo(String url) async {
    try {
      List<Map<String, dynamic>> allEntities = [];
      String? nextUrl = url;
      while (nextUrl != null) {
        var response = await dio.get(nextUrl);
        try {
          var dataInfo = response.data["info"];
          // So, we have info object and pagination
          Info info = Info.fromJson(response.data["info"]);
          nextUrl = info.next;
          allEntities.addAll(
              List<Map<String, dynamic>>.from(response.data["results"]));
        } catch (e) {
          // We don't have info object and pagination
          allEntities.addAll(List<Map<String, dynamic>>.from(response.data));
          nextUrl = null;
        }
      }

      return allEntities;
    } on DioException {
      rethrow;
    }
  }
}