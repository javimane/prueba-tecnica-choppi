
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';


import '../../entities/character.dart';
import '../delegates/search_character_delegate.dart';
import '../providers/providers.dart';
import '../providers/search_character_provider.dart';
import '../widgets/character_card.dart';
 //el consumerWidget funciona igual al StatellesWidget pero se usa asi para poder usar Riverpod

class CharactersScreen extends ConsumerWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 0.0),
            child: Text('Characters'),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final searchedCharacters = ref.read(searchedCharactersProvider);
              final searchQuery = ref.read(searchQueryProvider);

              showSearch<Character?>(
                query: searchQuery,
                context: context,
                delegate: SearchCharacterDelegate(
                  initialCharacters: searchedCharacters,
                  searchCharacters: ref
                      .read(searchedCharactersProvider.notifier)
                      .searchCharactersByQuery,
                ),
              ).then((character) {
                if (character == null) return;

                context.push('/character/${character.id}');
              });
            },
            icon: const Icon(
              Icons.search_rounded,
              size: 35,
            ),
          )
        ],
      ),
      body: const _CharactersView(),
    );
  }
}

class _CharactersView extends ConsumerStatefulWidget {
  const _CharactersView();

  @override
  _CharactersViewState createState() => _CharactersViewState();
}

class _CharactersViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadNextPageOnScroll);
    ref.read(charactersProvider.notifier).loadNextPage().whenComplete(() {
      isInitialLoading = false;
      setState(() {});
    });
  }

  void _loadNextPageOnScroll() {
    if (!isLoading && !isInitialLoading) {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        isLoading = true;
        ref.read(charactersProvider.notifier).loadNextPage().whenComplete(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await ref.read(charactersProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final charactersState = ref.watch(charactersProvider);

    return ConnectivityWidgetWrapper(
      disableInteraction: true,
      alignment: Alignment.topCenter,
      message: 'No estás conectado a internet',
      child: RefreshIndicator(
        onRefresh: _refreshData, // Lógica de recarga aquí
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: charactersState.characters.length + 1,
            itemBuilder: (context, index) {
              if (index < charactersState.characters.length) {
                final character = charactersState.characters[index];
                return GestureDetector(
                  onTap: () => context.push('/character/${character.id}'),
                  child: CharacterCard(character: character),
                );
              } else {
                return isLoading ? const CircularProgressIndicator() : const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

