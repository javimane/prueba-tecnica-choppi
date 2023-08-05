








import 'package:prueba_tecnica_choppi/features/characters/entities/character.dart';

class CharacterMapper {


  static fromJson( Map<String, dynamic> json ) => Character(
    id: json["id"],
        name: json["name"],
        status: json["status"],
        species: json["species"],
        type: json["type"],
        gender: json["gender"],
        origin: CharacterLocation.fromJson(json["origin"]),
        location: CharacterLocation.fromJson(json["location"]),
        image: json["image"],
        episode: List<String>.from(json["episode"].map((x) => x)),
        url: json["url"],
        created: DateTime.parse(json["created"]),
    
    
  );


}
