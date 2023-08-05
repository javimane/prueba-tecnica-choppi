import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../entities/character.dart';
import '../../repositories/characters_repository.dart';
import 'characters_repository_provider.dart';


final charactersProvider = StateNotifierProvider<CharactersNotifier, CharactersState>((ref) {

  final charactersRepository = ref.watch( charactersRepositoryProvider );
  return CharactersNotifier(
    charactersRepository: charactersRepository
  );
  
});




//como quiero que luzca la informacion de mi provider
class CharactersNotifier extends StateNotifier<CharactersState> {
  
  final CharactersRepository charactersRepository;

  CharactersNotifier({
    required this.charactersRepository
  }): super( CharactersState() ) {
    loadNextPage();
  }


  Future loadNextPage() async {

    if ( state.isLoading || state.isLastPage ) return;

    state = state.copyWith( isLoading: true );


    final characters = await charactersRepository
      .getAllCharacters();

    if ( characters.isEmpty ) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      page : state.page +1,
      characters: [...state.characters, ...characters ]
    );


  }

}





class CharactersState {

  final bool isLastPage;
  final int page;
  
  final bool isLoading;
  final List<Character> characters;

  CharactersState({
    this.isLastPage = false, 
    this.page = 1, 
    
    this.isLoading = false, 
    this.characters = const[]
  });

  CharactersState copyWith({
    bool? isLastPage,
    int? page,
    
    bool? isLoading,
    List<Character>? characters,
  }) => CharactersState(
    isLastPage: isLastPage ?? this.isLastPage,
    page: page ?? this.page,
    
    isLoading: isLoading ?? this.isLoading,
    characters: characters ?? this.characters,
  );

}
