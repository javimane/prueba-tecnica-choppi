import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../entities/character.dart';

import 'character_repository_provider.dart';
// Definición del StateNotifierProvider characterInfoProvider
final characterInfoProvider = StateNotifierProvider<CharacterNotifier, Map<int, Character>>((ref) {
  // Obtener el characterRepository del characterRepositoryProvider
  final characterRepository = ref.watch(characterRepositoryProvider);

  // Crear una instancia de CharacterNotifier pasando la función getCharacter del characterRepository
  return CharacterNotifier(getCharacter: characterRepository.getCharacterById);
});

// Definición del tipo de función GetCharacterCallback
typedef GetCharacterCallback = Future<Character> Function(int characterId);

// Clase CharacterNotifier que extiende de StateNotifier<Map<int, Character>>
class CharacterNotifier extends StateNotifier<Map<int, Character>> {
  final GetCharacterCallback getCharacter;

  // Constructor de CharacterNotifier que recibe la función getCharacter y un estado inicial vacío
  CharacterNotifier({
    required this.getCharacter,
  }) : super({});

  // Método para cargar un personaje por su ID
  Future<void> loadCharacter(int characterId) async {
    // Si el personaje ya está en el estado, se retorna sin hacer nada
    if (state[characterId] != null) return;

    // Se obtiene el personaje usando la función getCharacter
    final character = await getCharacter(characterId);

    // Se actualiza el estado con el nuevo personaje usando el operador spread (...)
    state = {...state, characterId: character};
  }
}
