import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 5.0,
        centerTitle: true,
        title: Text(
          'Rick and Morty Characters',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar personaje',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<CharactersProvider>(context, listen: false)
                  .fetchCharacters(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.error != null) {
                  return Center(
                    child: Text(
                      '¡Ups! Ha ocurrido un error al cargar los personajes. Inténtalo de nuevo más tarde.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  );
                } else {
                  return PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Provider.of<CharactersProvider>(context)
                        .characters
                        .length,
                    itemBuilder: (ctx, i) => Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                          Provider.of<CharactersProvider>(context)
                              .characters[i]
                              .image,
                          fit: BoxFit.cover),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
