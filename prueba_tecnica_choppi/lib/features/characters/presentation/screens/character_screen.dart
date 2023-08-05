// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../entities/character.dart';

import '../providers/character_provider.dart';

class CharacterScreen extends ConsumerStatefulWidget {
  final int characterId;

  const CharacterScreen({super.key, required this.characterId});

  @override
  CharacterScreenState createState() => CharacterScreenState();
}

class CharacterScreenState extends ConsumerState<CharacterScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(characterInfoProvider.notifier).loadCharacter(widget.characterId);
  }

  @override
  Widget build(BuildContext context) {
   
    final Character? character =
        ref.watch(characterInfoProvider)[widget.characterId];

    if (character == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }
           return Scaffold( // Mostrar el contenido normal de _CharacterDetails
            body: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                _CustomSliverAppBar(character: character),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _CharacterDetails(character: character),
                    childCount: 1,
                  ),
                ),
              ],
            ));
          }
        }
    



class _CharacterDetails extends StatelessWidget {
  final Character character;

  const _CharacterDetails({required this.character});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Titulo, OverView y Rating
        _TitleAndOverview(
            character: character, size: size, textStyles: textStyles),

        //* Generos de la película
      ],
    );
  }
}

class _TitleAndOverview extends StatelessWidget {
  const _TitleAndOverview({
    required this.character,
    required this.size,
    required this.textStyles,
  });

  final Character character;
  final Size size;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen

          const SizedBox(width: 10),

          // Descripción
          SizedBox(
            width: (size.width) * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(character.name, style: textStyles.titleLarge),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Estado:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(width: 5),
                    Text(character.status,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Tipo:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(width: 5),
                    Text(character.type.isNotEmpty ? character.type[0] : 'N/A',
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Género:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(width: 5),
                    Text(
                        character.gender.isNotEmpty
                            ? character.gender[0]
                            : 'N/A',
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Especie:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(width: 5),
                    Text(character.species,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Alinea el contenido al inicio del Row
                  children: [
                    const Text('Origen:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(width: 5),
                    Expanded(
                      child: SizedBox(
                        // Aquí utilizamos SizedBox para ajustar la altura del Row
                        height: 50, // Ajusta el valor según tu preferencia
                        child: Text(
                          character.origin.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Episodios:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 5),
                    Text(
                      character.episode
                          .map((episode) =>
                              episode.substring(episode.lastIndexOf('/') + 1))
                          .join(', '),
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends ConsumerWidget {
  final Character character;

  const _CustomSliverAppBar({required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  final isFavoriteFuture = ref.watch(isFavoriteProvider(character.id));
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
    
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        title: _CustomGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.7, 1.0],
            colors: [Colors.transparent, scaffoldBackgroundColor]),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                character.image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            //* Favorite Gradient Background
            const _CustomGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.0,
                  0.2
                ],
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ]),

            //* Back arrow background
            const _CustomGradient(begin: Alignment.topLeft, stops: [
              0.0,
              0.3
            ], colors: [
              Colors.black87,
              Colors.transparent,
            ]),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient(
      {this.begin = Alignment.centerLeft,
      this.end = Alignment.centerRight,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin, end: end, stops: stops, colors: colors))),
    );
  }
}
