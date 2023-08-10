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
        title: Text('Rick and Morty Characters'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar personaje',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              // Aquí puedes implementar la lógica de búsqueda si la API lo permite.
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<CharactersProvider>(context, listen: false)
                  .fetchCharacters(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: Provider.of<CharactersProvider>(context)
                        .characters
                        .length,
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(Provider.of<CharactersProvider>(context)
                          .characters[i]
                          .name),
                      // Aquí puedes agregar más detalles como una imagen o descripción.
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        // Aquí puedes manejar la navegación entre las diferentes páginas.
      ),
    );
  }
}
