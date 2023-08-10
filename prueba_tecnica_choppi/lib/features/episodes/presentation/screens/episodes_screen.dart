

import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prueba_tecnica_choppi/features/episodes/presentation/providers/episodes_provider.dart';



import '../widgets/episode_card.dart';

class EpisodesScreen extends ConsumerWidget { //el consumerWidget funciona igual al StatellesWidget pero se usa asi para poder usar Riverpod
  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    

    return Scaffold(
      
      appBar: AppBar(
        title: const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 60.0), // Ajusta el valor según tu preferencia
                child: Text('Episodes'),
            ),
          ),

      ),
      body:  const _EpisodesView()
    );
    
            }
          }
   

class _EpisodesView extends ConsumerStatefulWidget {
  const _EpisodesView();

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends ConsumerState {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    scrollController.addListener(() {
      if ( (scrollController.position.pixels + 400) >= scrollController.position.maxScrollExtent ) {
        ref.read(episodesProvider.notifier).loadNextPage();
      }
    });

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }



  @override
Widget build(BuildContext context) {
  final episodesState = ref.watch(episodesProvider); //watch es estar pendiente de...

      return ConnectivityWidgetWrapper(
        disableInteraction: true,
        alignment: Alignment.topCenter,
        message: 'No estas conectado a internet',
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/fondogalaxia.avif"),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: episodesState.episodes.length,
                itemBuilder: (context, index) {
                  final episode = episodesState.episodes[index];
      
                    return EpisodeCard(episode: episode);
                  },
                ),
              ),
            ),
      );

        
      }
    }
