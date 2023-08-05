
import 'package:prueba_tecnica_choppi/features/episodes/datasource/episodes_datasource.dart';

import '../entities/episode.dart';
import 'episodes_repository.dart';

class EpisodesRepositoryImpl extends EpisodesRepository {

  final EpisodeDatasource datasource;

  EpisodesRepositoryImpl(this.datasource);



  @override
  Future<Episode> getEpisodeById(int id) {
    return datasource.getEpisodeById(id);
  }

  @override
   Future<List<Episode>> getAllEpisodes() {
    return datasource.getAllEpisodes();
  }

  
 

}