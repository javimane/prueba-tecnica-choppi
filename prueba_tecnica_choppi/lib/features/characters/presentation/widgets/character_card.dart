import 'package:flutter/material.dart';


import '../../entities/character.dart';



class CharacterCard extends StatelessWidget {

  final Character character;

  const CharacterCard({
    super.key, 
    required this.character
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageViewer( characterImage: character),
        Text( character.name, textAlign: TextAlign.center, 
        style:const TextStyle( fontWeight: FontWeight.bold , fontSize: 20) , 
        ),
       
        const SizedBox(height: 20)
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {

  final Character characterImage;

  const _ImageViewer({ required this.characterImage });

  @override
  Widget build(BuildContext context) {
    
    if ( characterImage.image.isEmpty ) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset('assets/images/no-image.jpg', 
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FadeInImage(
        fit: BoxFit.cover,
        height: 250,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
        image: NetworkImage( characterImage.image ),
        placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
      ),
    );

  }
}