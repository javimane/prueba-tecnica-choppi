
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_choppi/features/characters/infrastructure/infrastructure.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../info/providers/info_datasource_provider.dart';

final characterRepositoryProvider = Provider((ref){
  final accessToken = ref.watch( authProvider ).user?.token ?? '';
  final infoData = ref.read(infoDatasourceProvider);
  return CharactersRepositoryImpl(CharactersDatasourceImpl(accessToken: accessToken, infoData: infoData ));
});