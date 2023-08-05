import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_service.dart';

// Clase que implementa la interfaz KeyValueStorageService
class KeyValueStorageServiceImpl extends KeyValueStorageService {
  
  // Método para obtener una instancia de SharedPreferences
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Implementación del método para obtener un valor almacenado en SharedPreferences
  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case int:
        return prefs.getInt(key) as T?;

      case String:
        return prefs.getString(key) as T?;

      default:
        // Si el tipo T no está implementado, lanzar una excepción
        throw UnimplementedError('GET not implemented for type ${T.runtimeType}');
    }
  }

  // Implementación del método para remover una clave de SharedPreferences
  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  // Implementación del método para guardar un valor en SharedPreferences
  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case int:
        prefs.setInt(key, value as int);
        break;

      case String:
        prefs.setString(key, value as String);
        break;

      default:
        // Si el tipo T no está implementado, lanzar una excepción
        throw UnimplementedError('Set not implemented for type ${T.runtimeType}');
    }
  }
}
