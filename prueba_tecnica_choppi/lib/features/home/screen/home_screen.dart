import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/connectivity/connectivity_provider.dart';
import '../items/menu_items.dart';
import '../../shared/shared.dart';

// Clase HomeScreen que muestra la pantalla principal de la aplicación
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el estado de la conexión a Internet
    final connectivityResult = ref.watch(connectivityProvider);

    // Crear una clave para el scaffold
    final scaffoldKey = GlobalKey<ScaffoldState>();

    // Obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    // Construir el scaffold principal
    return Scaffold(
      // Agregar un drawer (menú lateral) al scaffold
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Rick y Morty'),
      ),
      // Contenedor con una imagen de fondo
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/rickymorty.png'),
            fit: BoxFit.contain,
          ),
        ),
        // Builder para mostrar el AlertDialog según el estado de conexión
        child: Builder(
          builder: (context) {
            // Verificar el estado de la conexión y mostrar un mensaje si no hay conexión a Internet
            if (connectivityResult.when(
              data: (result) => result == ConnectivityResult.none,
              loading: () => false,
              error: (error, stackTrace) => false,
            )) {
              // Mostrar el AlertDialog directamente
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sin conexión a Internet'),
                  content: const Text('Por favor, asegúrate de estar conectado a una red.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );

              // No es necesario retornar nada aquí, ya que showDialog mostrará el AlertDialog
              return const SizedBox.shrink();
            } else {
              // Mostrar el contenido normal de _HomeView
              return const _HomeView();
            }
          },
        ),
      ),
    );
  }
}

// Clase _HomeView que muestra la lista de elementos en la pantalla principal
class _HomeView extends StatefulWidget {
  const _HomeView();
  @override
  _HomeViewState createState() => _HomeViewState();
}

// Estado de _HomeView
class _HomeViewState extends State<_HomeView> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Construir una lista desplazable con elementos de la lista appMenuItems
    return ListView.builder(
      controller: scrollController,
      itemCount: appMenuItems.length,
      itemBuilder: (context, index) {
        final menuItem = appMenuItems[index];

        // Construir un ListTile personalizado para cada elemento de la lista
        return _CustomListTile(menuItem: menuItem);
      },
    );
  }
}

// Widget que representa un ListTile personalizado
class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.menuItem,
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Construir un ListTile con un ícono, un texto y una función onTap para redirigir a la ruta correspondiente
    return ListTile(
      leading: menuItem.icon,
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: colors.primary),
      title: Text(
        menuItem.title,
        style: const TextStyle(
          fontSize: 25,
        ),
      ),
      onTap: () {
        context.push(menuItem.link);
      },
    );
  }
}
