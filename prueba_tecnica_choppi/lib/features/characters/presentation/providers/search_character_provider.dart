import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_choppi/features/characters/entities/character.dart';
import 'package:prueba_tecnica_choppi/features/characters/presentation/providers/characters_repository_provider.dart';




// Definición del StateProvider searchQueryProvider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Definición del StateNotifierProvider searchedCharactersProvider
final searchedCharactersProvider = StateNotifierProvider<SearchedCharactersNotifier, List<Character>>((ref) {
  // Obtener el charactersRepository del charactersRepositoryProvider
  final charactersRepository = ref.read(charactersRepositoryProvider);

  // Crear una instancia de SearchedCharactersNotifier con el searchCharacter y ref
  return SearchedCharactersNotifier(
    searchCharacter: charactersRepository.searchCharacter, 
    ref: ref,
  );
});

// Definición del tipo de función SearchCharactersCallback
typedef SearchCharactersCallback = Future<List<Character>> Function(String query);

// Clase SearchedCharactersNotifier que extiende de StateNotifier<List<Character>>
class SearchedCharactersNotifier extends StateNotifier<List<Character>> {
  final SearchCharactersCallback searchCharacter; // Función para buscar personajes
  final Ref ref; // Referencia al contexto de Riverpod

  // Constructor de SearchedCharactersNotifier
  SearchedCharactersNotifier({
    required this.searchCharacter,
    required this.ref,
  }) : super([]); // Se inicia con una lista vacía de personajes

  // Función para buscar personajes por su nombre (query)
  Future<List<Character>> searchCharactersByQuery(String query) async {
    // Llamar a la función searchCharacter para obtener la lista de personajes
    final List<Character> characters = await searchCharacter(query);
    
    // Actualizar el valor del searchQueryProvider con el valor actual de query
    ref.read(searchQueryProvider.notifier).update((state) => query);

    // Actualizar el estado del SearchedCharactersNotifier con la lista de personajes obtenida
    state = characters;
    
    // Devolver la lista de personajes
    return characters;
  }
}


