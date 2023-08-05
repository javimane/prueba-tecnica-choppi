
import 'package:prueba_tecnica_choppi/features/characters/entities/character.dart';




abstract class CharacterDatasource {
   Future<List<Character>> getAllCharacters(); //skip seria cada pagina
  Future<Character> getCharacterById(int id);

  Future<List<Character>> searchCharacter( String query );
  
  
}