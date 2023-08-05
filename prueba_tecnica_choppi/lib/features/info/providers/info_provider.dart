import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_choppi/features/info/providers/info_repository_provider.dart';

import '../repositories/info_repository.dart';







// Proveedor de estado
final infoProvider = StateNotifierProvider<InfoNotifier, InfosState>((ref) {
  final infoRepository = ref.watch(infoRepositoryProvider);
  return InfoNotifier(
    infoRepository: infoRepository);
});

// Clase InfoNotifier que extiende de StateNotifier
class InfoNotifier extends StateNotifier<InfosState> {
  final InfoRepository infoRepository;

  InfoNotifier({
    required this.infoRepository,
    
  }) : super(InfosState()) {
    // Puedes inicializar el estado aquí si es necesario
  }

  // Método para actualizar la información
  void updateInfo(String newInfoText) {
    state = state.copyWith(infoText: newInfoText);
  }

  // Otros métodos y lógica relacionada con la gestión del estado
}

   // Modelo de estado
class InfosState {
  String infoText;

  InfosState({this.infoText = ""});

  InfosState copyWith({String? infoText}) {
    return InfosState(
      infoText: infoText ?? this.infoText,
    );
  }
}




