
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_choppi/features/info/infrastructure/datasources/info_datasource_impl.dart';
import 'package:prueba_tecnica_choppi/features/info/repositories/info_repository.dart';
import 'package:prueba_tecnica_choppi/features/info/repositories/info_repository_impl.dart';

import '../../auth/presentation/providers/auth_provider.dart';




//este provider es para crear una instancia de los repositorios y su implementacion para poder usarlo en toda la app
final infoRepositoryProvider = Provider<InfoRepository>((ref) { //ref llamo a mi arbol de providers de riverpod
  
  final accessToken = ref.watch( authProvider ).user?.token ?? '';
  
  final infoRepository = InfoRepositoryImpl(
    InfoDatasourceImpl(accessToken: accessToken  )
  );

  return infoRepository;
});

