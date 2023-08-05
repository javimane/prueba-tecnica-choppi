
import 'package:dio/dio.dart';

import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';


class AuthDataSourceImpl extends AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrlLogin
    )
  );


 @override
  Future<User> checkAuthStatus(String token) async {
    
    try {
      
      final response = await dio.get('/auth/RESOURCE',
        options: Options(
          headers: {
            'Authorization': 'Bearer /* $token */',
            'Content-Type' : 'aplication/json'
          }
        )
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;


    } on DioException catch (e) {
      if( e.response?.statusCode == 401 ){
         throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<User> login(String username, String password) async {
    
    try {
      final response = await dio.post('/auth/login', data: {
        'username': username,
        'password': password
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
      
    } on DioException catch (e) {
      if( e.response?.statusCode == 401 ){
         throw CustomError(e.response?.data['message'] ?? 'Credenciales incorrectas' );
      }
      if ( e.type == DioExceptionType.connectionTimeout ){
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }


  }


}
