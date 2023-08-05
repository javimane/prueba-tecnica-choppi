import 'package:dio/dio.dart';
import 'package:prueba_tecnica_choppi/features/info/datasource/info_datasource.dart';


import '../../../../config/config.dart';

import '../../../auth/infrastructure/infrastructure.dart';
import '../../datasource/character_datasource.dart';
import '../../entities/character.dart';
import '../../errors/character_errors.dart';
import '../mappers/character_mapper.dart';



class CharactersDatasourceImpl extends CharacterDatasource {

  late final Dio dio;
  final String accessToken;
final InfoDatasource infoData;
  CharactersDatasourceImpl({
    required this.accessToken,
    required this.infoData
  }) : dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
     
    )
  );



  @override
  Future<Character> getCharacterById(int id)async {
   try {
      
      final response = await dio.get('/character/$id');
      final character = CharacterMapper.fromJson(response.data);
      return character;

    } on DioException catch (e) {
      if ( e.response!.statusCode == 404 ) throw CharacterNotFound();
     
      if ( e.type == DioExceptionType.connectionTimeout ){
        throw CustomError('Revisar conexión a internet');
      }
       throw Exception();
    }catch (e) {
      throw Exception();
    }
  }
  @override
  Future<List<Character>> getAllCharacters() async {
   try{ List<Map<String, dynamic>> objects = await 
        infoData.getInfo('/character');

    return List<Character>.from(objects.map((x) => Character.fromJson(x)));
  }on DioException catch (e) {
     
      if ( e.type == DioExceptionType.connectionTimeout ){
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  
  

  @override
  Future<List<Character>> searchCharacter(String query) async{
    if ( query.isEmpty ) return [];
    List<Map<String, dynamic>> objects = await 
        infoData.getInfo('/character/?{$query}');
        
    

    return List<Character>.from(objects.map((x) => Character.fromJson(x)));
   
    
       
  

  }
  

}