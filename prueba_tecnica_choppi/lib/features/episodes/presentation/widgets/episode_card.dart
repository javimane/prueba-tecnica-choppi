

import 'package:flutter/material.dart';



import '../../entities/episode.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;

  const EpisodeCard({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   final size = MediaQuery.of(context).size;
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Card(
      elevation: 8, // Controla la intensidad de la sombra
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Colors.white,
      child: Container(
        width: (size.width) * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 14, 146, 228), width: 4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           _EpisodeInfoRow(label: 'Nº', value: '${episode.id}   ${episode.episode}'),
           _EpisodeInfoRow(label: '', value: episode.name),
           _EpisodeInfoRow(label: '', value: episode.airDate),
          
          ],
        ),
      ),
    ),
    const SizedBox(height: 10),
  ],
   );

  }
}
class _EpisodeInfoRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _EpisodeInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Text(
        '$label$value',
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 19),
      ),
    );
  }
}


 



