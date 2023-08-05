
import 'package:dio/dio.dart';
import 'package:prueba_tecnica_choppi/features/episodes/datasource/episodes_datasource.dart';
import 'package:prueba_tecnica_choppi/features/episodes/errors/episode_errors.dart';

import '../../../../config/config.dart';
import '../../../auth/infrastructure/infrastructure.dart';
import '../../../info/datasource/info_datasource.dart';
import '../../entities/episode.dart';
import '../mappers/episode_mapper.dart';

class EpisodesDatasourceImpl extends EpisodeDatasource {

  late final Dio dio;
  final String accessToken;
  final InfoDatasource infoData;

  EpisodesDatasourceImpl( {
    required this.accessToken,
    required this.infoData
  }) : dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
     
    )
  );


  

  @override
  Future<Episode> getEpisodeById(int id)async {
   try {
      
      final response = await dio.get('/episode/$id');
      final episode = EpisodeMapper.fromJson(response.data);
      return episode;

    } on DioException catch (e) {
      if ( e.response!.statusCode == 404 ) throw EpisodeNotFound();
        
      if ( e.type == DioExceptionType.connectionTimeout ){
        throw CustomError('Revisar conexión a internet');
      }
     throw Exception();
    }catch (e) {
      throw Exception();
    }
  }
@override
  Future<List<Episode>> getAllEpisodes() async {
  try{  List<Map<String, dynamic>> objects = await 
        infoData.getInfo('/episode');

    return List<Episode>.from(objects.map((x) => Episode.fromJson(x)));
  }on DioException catch (e) {
      
      if ( e.type == DioExceptionType.connectionTimeout ){
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

}