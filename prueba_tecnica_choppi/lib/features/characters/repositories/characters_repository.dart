import '../entities/character.dart';

abstract class CharactersRepository {
   Future<List<Character>> getAllCharacters(); //skip seria cada pagina
  Future<Character> getCharacterById(int id);

  Future<List<Character>> searchCharacter( String query );
  
  
}