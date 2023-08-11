import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../models/character.dart'; // Asegúrate de importar tu modelo Character aquí

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Método para mostrar la información del personaje
  void _showCharacterInfo(BuildContext context, Character character) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(character.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(character.image),
            SizedBox(height: 16),
            Text('Status: ${character.status}'),
            Text('Species: ${character.species}'),
            Text('Type: ${character.type}'),
            Text('Gender: ${character.gender}'),
            Text('Origin: ${character.origin.name}'),
            Text('Location: ${character.location.name}'),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rick and Morty Characters'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFF2F1B4E),
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
                  return Center(child: Text('An error occurred!'));
                } else {
                  return PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Provider.of<CharactersProvider>(context)
                        .characters
                        .length,
                    itemBuilder: (ctx, i) => GestureDetector(
                      onTap: () {
                        _showCharacterInfo(
                            context,
                            Provider.of<CharactersProvider>(context,
                                    listen: false)
                                .characters[i]);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          Provider.of<CharactersProvider>(context,
                                  listen: false)
                              .characters[i]
                              .image,
                          fit: BoxFit.cover,
                        ),
                      ),
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
