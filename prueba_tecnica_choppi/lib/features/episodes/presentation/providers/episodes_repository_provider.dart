//este provider es para crear una instancia de los repositorios y su implementacion para poder usarlo en toda la app
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prueba_tecnica_choppi/features/episodes/infranstructure/datasources/episodes_datasource.impl.dart';
import 'package:prueba_tecnica_choppi/features/episodes/repositories/episodes_repository_impl.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../info/providers/info_datasource_provider.dart';
import '../../repositories/episodes_repository.dart';

final episodesRepositoryProvider = Provider<EpisodesRepository>((ref) { //ref llamo a mi arbol de providers de riverpod
  
  final accessToken = ref.watch( authProvider ).user?.token ?? '';
  final infoData = ref.read(infoDatasourceProvider);
  final productsRepository = EpisodesRepositoryImpl(
    EpisodesDatasourceImpl(accessToken: accessToken , infoData: infoData )
  );

  return productsRepository;
});