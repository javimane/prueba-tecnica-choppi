

import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_choice_chip/flutter_3d_choice_chip.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';



import '../items/menu_items.dart';
import '../../shared/shared.dart';

// Clase HomeScreen que muestra la pantalla principal de la aplicación
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el estado de la conexión a Internet
    

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
        title: const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 50), // Ajusta el valor según tu preferencia
                child: Text('Rick y Morty'),
            ),
          ),

      ),
      // Contenedor con una imagen de fondo
      body: ConnectivityWidgetWrapper(
        disableInteraction: true,
        alignment: Alignment.topCenter,
        message: 'No estas conectado a internet',
        
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo-galaxia2.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            // Builder para mostrar el AlertDialog según el estado de conexión

            // Mostrar el contenido normal de _HomeView
            child: const _HomeView(),
          ),
        )
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
   // final colors = Theme.of(context).colorScheme;
 final size = MediaQuery.of(context).size;
 return Container(
      margin: const EdgeInsets.all(15),
      child: ChoiceChip3D(
         
        height: (size.height) * 0.2,
        width: (size.width) * 0.80,
        style: ChoiceChip3DStyle(
          topColor: const Color.fromARGB(255, 206, 201, 201),
          backColor: Colors.red,
          borderRadius: BorderRadius.circular(3)
        ),
        selected: false,
        child: Column(
          children: [
            const SizedBox(height: 40,),
            menuItem.icon,
            const SizedBox(height: 5),
            Text(menuItem.title, style: const TextStyle(fontSize: 25, color: Colors.black)),
          ],
        ),
        onSelected: () {
          // Navegar a la página siguiente
          context.push(menuItem.link);
        },
        onUnSelected: (){},
      ),
    );

 
         /* return GestureDetector(
            onTap: () {
              // Navegar a la página siguiente
              context.push(menuItem.link);
            },
            child: Transform(
              transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateX(0.3),
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Cambia la dirección de la sombra
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    menuItem.icon,
                    const SizedBox(height: 8),
                    Text(menuItem.title, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            )
          );*/
        }
    

    // Construir un ListTile con un ícono, un texto y una función onTap para redirigir a la ruta correspondiente
   /* return ListTile(
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
  }*/
}
