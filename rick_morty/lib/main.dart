import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "./screens/home.dart";
import "./providers/character_provider.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CharactersProvider(),
      child: MaterialApp(
        title: 'Rick & Morty App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
