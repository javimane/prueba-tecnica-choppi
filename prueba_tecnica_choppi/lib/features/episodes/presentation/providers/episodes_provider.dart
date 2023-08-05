import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_choppi/features/episodes/entities/episode.dart';
import 'package:prueba_tecnica_choppi/features/episodes/repositories/episodes_repository.dart';

import 'episodes_repository_provider.dart';

// Definición del StateNotifierProvider episodesProvider
final episodesProvider = StateNotifierProvider<EpisodesNotifier, EpisodesState>((ref) {
  // Obtener el episodesRepository del episodesRepositoryProvider
  final episodesRepository = ref.watch(episodesRepositoryProvider);

  // Crear una instancia de EpisodesNotifier con el episodesRepository
  return EpisodesNotifier(
    episodesRepository: episodesRepository,
  );
});

// Clase EpisodesNotifier que extiende de StateNotifier<EpisodesState>
class EpisodesNotifier extends StateNotifier<EpisodesState> {
  final EpisodesRepository episodesRepository; // Repositorio de episodios

  // Constructor de EpisodesNotifier
  EpisodesNotifier({
    required this.episodesRepository,
  }) : super(EpisodesState()) {
    // Cargar la siguiente página al iniciar el notifier
    loadNextPage();
  }

  // Función para cargar la siguiente página de episodios
  Future loadNextPage() async {
    // Si ya se está cargando o es la última página, no hacer nada
    if (state.isLoading || state.isLastPage) return;

    // Indicar que se está cargando la siguiente página
    state = state.copyWith(isLoading: true);

    // Obtener la siguiente página de episodios desde el repositorio
    final episodes = await episodesRepository.getAllEpisodes();

    // Si no hay episodios, indicar que es la última página
    if (episodes.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    // Actualizar el estado con los episodios cargados y avanzar el contador de skip
    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      skip: state.skip + 10,
      episodes: [...state.episodes, ...episodes],
    );
  }
}

// Clase EpisodesState que define el estado del EpisodesNotifier
class EpisodesState {
  final bool isLastPage; // Indica si es la última página de episodios
  final int limit; // Límite de episodios por página
  final int skip; // Contador para paginación
  final bool isLoading; // Indica si se está cargando la siguiente página
  final List<Episode> episodes; // Lista de episodios cargados

  EpisodesState({
    this.isLastPage = false,
    this.limit = 10,
    this.skip = 0,
    this.isLoading = false,
    this.episodes = const [],
  });

  // Método copyWith para copiar y modificar el estado
  EpisodesState copyWith({
    bool? isLastPage,
    int? limit,
    int? skip,
    bool? isLoading,
    List<Episode>? episodes,
  }) =>
      EpisodesState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        skip: skip ?? this.skip,
        isLoading: isLoading ?? this.isLoading,
        episodes: episodes ?? this.episodes,
      );
}

