

import '../entities/episode.dart';

abstract class EpisodeDatasource {
   Future<List<Episode>> getAllEpisodes(); //skip seria cada pagina
  Future<Episode> getEpisodeById(int id);

 
}