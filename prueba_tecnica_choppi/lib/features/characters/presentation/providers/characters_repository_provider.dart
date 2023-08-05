
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_choppi/features/info/providers/info_datasource_provider.dart';


import '../../../auth/presentation/providers/auth_provider.dart';

import '../../infrastructure/infrastructure.dart';
import '../../repositories/characters_repository.dart';

//este provider es para crear una instancia de los repositorios y su implementacion para poder usarlo en toda la app
final charactersRepositoryProvider = Provider<CharactersRepository>((ref) {
  // Obtener el accessToken del usuario autenticado o una cadena vacía si no está autenticado
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  // Obtener el infoData del infoDatasourceProvider
  final infoData = ref.read(infoDatasourceProvider); // Accedemos al estado de infoProvider con ".state"
  // Crear una instancia de CharactersRepositoryImpl con CharactersDatasourceImpl
  final charactersRepository = CharactersRepositoryImpl(
    CharactersDatasourceImpl(accessToken: accessToken, infoData: infoData),
  );

  return charactersRepository;
});


