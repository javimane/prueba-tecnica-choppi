
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';


// Se define el Provider goRouterNotifierProvider que crea una instancia de GoRouterNotifier
final goRouterNotifierProvider = Provider((ref) {
  // Se obtiene una referencia al AuthNotifier a través del authProvider
  final authNotifier = ref.read(authProvider.notifier);
  // Se crea una instancia de GoRouterNotifier pasándole el AuthNotifier
  return GoRouterNotifier(authNotifier);
});

// Clase GoRouterNotifier que extiende de ChangeNotifier
class GoRouterNotifier extends ChangeNotifier {

  // Se declara una variable privada _authNotifier que almacena una referencia al AuthNotifier
  final AuthNotifier _authNotifier;

  // Se declara una variable privada _authStatus que almacena el estado de autenticación
  AuthStatus _authStatus = AuthStatus.checking;

  // Constructor de GoRouterNotifier que recibe el AuthNotifier
  GoRouterNotifier(this._authNotifier) {
    // Se agrega un listener al AuthNotifier para estar pendiente de cambios en su estado
    _authNotifier.addListener((state) {
      // Cuando cambie el estado del AuthNotifier, se actualiza el _authStatus y se notifica a los listeners
      authStatus = state.authStatus;
    });
  }

  // Getter para obtener el estado de autenticación
  AuthStatus get authStatus => _authStatus;

  // Setter para actualizar el estado de autenticación y notificar a los listeners
  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }

}
