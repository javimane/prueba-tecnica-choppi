import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../entities/character.dart';


typedef SearchCharactersCallback = Future<List<Character>> Function( String query );

class SearchCharacterDelegate extends SearchDelegate<Character?>{


  final SearchCharactersCallback searchCharacters;
  List<Character> initialCharacters;
  
  StreamController<List<Character>> debouncedCharacters = StreamController.broadcast(); //broadcast es escuchar permanentemente el controller
  StreamController<bool> isLoadingStream = StreamController.broadcast();


  Timer? _debounceTimer;

  SearchCharacterDelegate({
    required this.searchCharacters,
    required this.initialCharacters,
  }):super(
    searchFieldLabel: 'Buscar Personajes',
    // textInputAction: TextInputAction.done
  );

  void clearStreams() {
    debouncedCharacters.close();
  }

  void _onQueryChanged( String query ) {
    isLoadingStream.add(true);

    if ( _debounceTimer?.isActive ?? false ) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration( milliseconds: 500 ), () async {
      // if ( query.isEmpty ) {
      //   debouncedCharacters.add([]);
      //   return;
      // }

      final characters = await searchCharacters( query );
      initialCharacters = characters;
      debouncedCharacters.add(characters);
      isLoadingStream.add(false);

    });

  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialCharacters,
      stream: debouncedCharacters.stream,
      builder: (context, snapshot) {
        
        final characters = snapshot.data ?? [];

        return ListView.builder(
          itemCount: characters.length,
          itemBuilder: (context, index) => _CharacterItem(
            character: characters[index],
            onCharacterSelected: (context, character) {
              clearStreams();
              close(context, character);
            },
          ),
        );
      },
    );
  }


  // @override
  // String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {

    return [

      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
            if ( snapshot.data ?? false ) {
              return SpinPerfect(
                  duration: const Duration(seconds: 20),
                  spins: 10,
                  infinite: true,
                  child: IconButton(
                    onPressed: () => query = '', 
                    icon: const Icon( Icons.refresh_rounded )
                  ),
                );
            }

             return FadeIn(
                animate: query.isNotEmpty,
                child: IconButton(
                  onPressed: () => query = '', 
                  icon: const Icon( Icons.clear )
                ),
              );

        },
      ),
      
       
        



    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
          clearStreams();
          close(context, null);
        }, 
        icon: const Icon( Icons.arrow_back_ios_new_rounded)
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);
    return buildResultsAndSuggestions();

  }

}

class _CharacterItem extends StatelessWidget {

  final Character character;
  final Function onCharacterSelected;

  const _CharacterItem({
    required this.character,
    required this.onCharacterSelected
  });

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onCharacterSelected(context, character);
      },
      child: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
          
              // Image
              SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    height: 130,
                    fit: BoxFit.cover,
                    image: NetworkImage(character.image),
                    placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                  )
                ),
              ),
          
              const SizedBox(width: 10),
              
              // Description
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( character.name, style: textStyles.titleMedium ),
          
                 
          
                    
                  ],
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}