
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_choppi/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:prueba_tecnica_choppi/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

import '../../domain/domain.dart';
import '../../infrastructure/infrastructure.dart';

// Se define el StateNotifierProvider llamado authProvider que crea una instancia de AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  // Se crean instancias del AuthRepositoryImpl y KeyValueStorageServiceImpl
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  // Se retorna una instancia de AuthNotifier pasándole las dependencias creadas
  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});


// Clase AuthNotifier que extiende de StateNotifier<AuthState>
class AuthNotifier extends StateNotifier<AuthState> {

  // Variables que almacenan las dependencias necesarias
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  // Constructor de AuthNotifier que recibe las dependencias y un estado inicial de AuthState
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    // Al crear una instancia de AuthNotifier, se ejecuta automáticamente el método checkAuthStatus
    checkAuthStatus();
  }

  // Método para iniciar sesión de usuario
  Future<void> loginUser(String username, String password) async {
    // Simulamos una demora de 500 milisegundos
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Intentamos iniciar sesión llamando al método login del AuthRepository
      final user = await authRepository.login(username, password);
      // Si el inicio de sesión es exitoso, llamamos al método _setLoggedUser
      _setLoggedUser(user);
    } on CustomError catch (e) {
      // Si hay un CustomError, llamamos al método logout con el mensaje de error
      logout(e.message);
    } catch (e) {
      // Si hay cualquier otro error, llamamos al método logout con un mensaje de error genérico
      logout('Usuario y/o Contraseña Inválido');
    }
  }

  // Método para verificar el estado de autenticación del usuario
  void checkAuthStatus() async {
    // Obtenemos el token del KeyValueStorageService
    final token = await keyValueStorageService.getValue<String>('token');
    // Si no hay token, llamamos al método logout
    if (token == null) return logout();

    try {
      // Intentamos verificar el estado de autenticación llamando al método checkAuthStatus del AuthRepository
      final user = await authRepository.checkAuthStatus(token);
      // Si el estado de autenticación es exitoso, llamamos al método _setLoggedUser
      _setLoggedUser(user);
    } catch (e) {
      // Si hay algún error, llamamos al método logout
      logout();
    }
  }

  // Método privado para establecer al usuario como autenticado
  void _setLoggedUser(User user) async {
    // Guardamos el token del usuario en el KeyValueStorageService
    await keyValueStorageService.setKeyValue('token', user.token);

    // Actualizamos el estado de AuthState con los nuevos valores
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  // Método para cerrar sesión del usuario
  Future<void> logout([String? errorMessage]) async {
    // Removemos el token del KeyValueStorageService
    await keyValueStorageService.removeKey('token');

    // Actualizamos el estado de AuthState con los nuevos valores
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage ?? '',
    );
  }
}


// Enum para representar los diferentes estados de autenticación
enum AuthStatus { checking, authenticated, notAuthenticated }

// Clase AuthState que representa el estado de autenticación
class AuthState {
  final AuthStatus authStatus; // Estado de autenticación
  final User? user; // Usuario autenticado
  final String errorMessage; // Mensaje de error (si lo hay)

  // Constructor de AuthState con parámetros opcionales y valores por defecto
  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  // Método copyWith para crear una nueva instancia de AuthState con valores actualizados
  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
