
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../shared/shared.dart';
import 'auth_provider.dart';


// Se define el StateNotifierProvider llamado loginFormProvider que crea una instancia de LoginFormNotifier
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  // Se obtiene el callback loginUser del authProvider para iniciar sesión
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

  // Se retorna una instancia de LoginFormNotifier pasándole el callback loginUser
  return LoginFormNotifier(
    loginUserCallback: loginUserCallback,
  );
});


// Clase LoginFormNotifier que extiende de StateNotifier<LoginFormState>
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;

  // Constructor de LoginFormNotifier que recibe el callback loginUser y un estado inicial de LoginFormState
  LoginFormNotifier({
    required this.loginUserCallback,
  }) : super(LoginFormState());

  // Método para cambiar el valor del campo de correo electrónico
  onEmailChange(String value) {
    // Se crea una nueva instancia de UserName.dirty con el nuevo valor
    final newUserName = UserName.dirty(value);
    // Se actualiza el estado de LoginFormState con el nuevo valor y se valida el formulario
    state = state.copyWith(
      username: newUserName,
      isValid: Formz.validate([newUserName, state.password]),
    );
  }

  // Método para cambiar el valor del campo de contraseña
  onPasswordChanged(String value) {
    // Se crea una nueva instancia de Password.dirty con el nuevo valor
    final newPassword = Password.dirty(value);
    // Se actualiza el estado de LoginFormState con el nuevo valor y se valida el formulario
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.username]),
    );
  }

  // Método para enviar el formulario de inicio de sesión
  onFormSubmit() async {
    // Se llama al método _touchEveryField para "tocar" todos los campos del formulario
    _touchEveryField();

    // Si el formulario no es válido, se retorna sin hacer nada
    if (!state.isValid) return;

    // Se indica que se está enviando el formulario
    state = state.copyWith(isPosting: true);

    // Se llama al callback loginUserCallback para iniciar sesión
    await loginUserCallback(state.username.value, state.password.value);

    // Se indica que se ha terminado de enviar el formulario
    state = state.copyWith(isPosting: false);
  }

  // Método privado para "tocar" todos los campos del formulario
  _touchEveryField() {
    final username = UserName.dirty(state.username.value);
    final password = Password.dirty(state.password.value);

    // Se actualiza el estado de LoginFormState con los nuevos valores y se valida el formulario
    state = state.copyWith(
      isFormPosted: true,
      username: username,
      password: password,
      isValid: Formz.validate([username, password]),
    );
  }
}

// Estado del formulario de inicio de sesión
class LoginFormState {
  final bool isPosting; // Indica si se está enviando el formulario
  final bool isFormPosted; // Indica si se ha enviado el formulario
  final bool isValid; // Indica si el formulario es válido
  final UserName username; // Campo de correo electrónico
  final Password password; // Campo de contraseña

  // Constructor de LoginFormState con parámetros opcionales y valores por defecto
  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.username = const UserName.pure(),
    this.password = const Password.pure(),
  });

  // Método copyWith para crear una nueva instancia de LoginFormState con valores actualizados
  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    UserName? username,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        username: username ?? this.username,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
    LoginFormState:
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      userName: $username
      password: $password
  ''';
  }
}
