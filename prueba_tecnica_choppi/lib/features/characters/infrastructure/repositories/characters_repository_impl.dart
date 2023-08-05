

import 'package:prueba_tecnica_choppi/features/characters/entities/character.dart';
import 'package:prueba_tecnica_choppi/features/characters/infrastructure/infrastructure.dart';
import 'package:prueba_tecnica_choppi/features/characters/repositories/characters_repository.dart';





class CharactersRepositoryImpl extends CharactersRepository {

  final CharactersDatasourceImpl datasource;

  CharactersRepositoryImpl(this.datasource);


  

  @override
  Future<Character> getCharacterById(int id) {
    return datasource.getCharacterById(id);
  }

  @override
   Future<List<Character>> getAllCharacters() {
    return datasource.getAllCharacters();
  }

  
  @override
  Future<List<Character>> searchCharacter(String query) {
    return datasource.searchCharacter(query);
  }
  
  

}