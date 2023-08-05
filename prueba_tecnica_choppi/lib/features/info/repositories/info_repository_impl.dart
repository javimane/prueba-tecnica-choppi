


import '../datasource/info_datasource.dart';
import 'info_repository.dart';



class InfoRepositoryImpl extends InfoRepository {

  final InfoDatasource datasource;

  InfoRepositoryImpl(this.datasource);


  @override
   Future<List<Map<String, dynamic>>> getInfo(String url) {
    return datasource.getInfo(url);
  }     
  

}