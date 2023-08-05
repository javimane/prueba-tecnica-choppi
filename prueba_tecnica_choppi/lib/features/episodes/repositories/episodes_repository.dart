import '../entities/episode.dart';

abstract class EpisodesRepository {
   Future<List<Episode>> getAllEpisodes(); //skip seria cada pagina
  Future<Episode> getEpisodeById(int id);

 
}