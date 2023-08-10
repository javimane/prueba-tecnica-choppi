



import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((ref) => ConnectivityNotifier());

class ConnectivityNotifier extends StateNotifier<bool> {
  ConnectivityNotifier() : super(false);

  void checkConnectivity() async {
    state = await ConnectivityWrapper.instance.isConnected;
  }
}




/*final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> controller = StreamController<ConnectivityResult>();

  void updateConnectionStatus(ConnectivityResult result) {
    controller.add(result);
  }

  void initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print("Couldn't check connectivity status: $e");
      result = ConnectivityResult.none;
    }
    updateConnectionStatus(result);
    _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  initConnectivity();

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
});
*/
/*final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
});*/
/*final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, ConnectivityResult>((ref) {
  final connectivity = Connectivity();
  final initialResult = ConnectivityResult.none;
  final notifier = ConnectivityNotifier(connectivity, initialResult);
  notifier.initializeConnectivityListener();
  return notifier;
});

class ConnectivityNotifier extends StateNotifier<ConnectivityResult> {
  final Connectivity _connectivity;

  ConnectivityNotifier(this._connectivity, ConnectivityResult initialResult)
      : super(initialResult);

  void initializeConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((result) {
      state = result; // Actualizar el estado con el resultado de la conectividad
    });
  }
}*/




/*final connectivityProvider = StreamProvider.autoDispose<ConnectivityResult>((ref) async* {
  final connectivity = Connectivity();
  yield await connectivity.checkConnectivity();

  // Escuchamos el evento de cambio de conectividad
  await for (var result in connectivity.onConnectivityChanged) {
    yield result;
  }
});*/
