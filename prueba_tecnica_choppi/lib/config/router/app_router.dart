
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';




import '../../features/auth/auth.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/characters/presentation/screens/character_screen.dart';
import '../../features/characters/presentation/screens/characters_screen.dart';
import '../../features/episodes/presentation/screens/episodes_screen.dart';
import '../../features/home/screen/home_screen.dart';

import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {

  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

     
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
       GoRoute(
        path: '/characters',
        builder: (context, state) =>  const CharactersScreen(),
      ),
      GoRoute(
            path: '/episodes',
            pageBuilder: (context, state) {
           
              return CustomTransitionPage(
                key: state.pageKey,
                child: const EpisodesScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                     
                     const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.bounceIn;

                   //   final tween = Tween(begin: begin, end: end);
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      );

                   return   RotationTransition(
                    turns: curvedAnimation,
                    child: ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
            ),
          ),
        );
              },
            );
          },
        ),
      
      GoRoute(
        path: '/character/:id',
        builder: (context, state) => CharacterScreen(
          characterId: int.parse(state.params['id'] ?? '0',
        ),
        ),
      ),
    ],
   

    redirect: (context, state) {
      
      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if ( isGoingTo == '/splash' && authStatus == AuthStatus.checking ) return null;

      if ( authStatus == AuthStatus.notAuthenticated ) {
        if ( isGoingTo == '/login' || isGoingTo == '/register' ) return null;

        return '/login';
      }

      if ( authStatus == AuthStatus.authenticated ) {
        if ( isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splash' ){
           return '/';
        }
      }


      return null;
    },
  );
});
