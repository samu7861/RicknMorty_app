import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty_app/screens/character.dart';
import 'package:rick_morty_app/screens/home.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(routes: [
  GoRoute(
      path: "/",
      builder: (context, state) {
        return HomeSs();
      }),
  GoRoute(
      path: "/character",
      builder: (context, state) {
        return const CharacterSs();
      })
]);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Rick and Morty',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark),
        routerConfig: _router);
  }
}
