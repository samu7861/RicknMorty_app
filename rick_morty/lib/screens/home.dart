import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/character_provider.dart';
import '../models/character.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchText = '';
  late List<Character> _filteredCharacters = [];

  @override
  void initState() {
    super.initState();
    _fetchAndFilterCharacters();
  }

  Future<void> _fetchAndFilterCharacters() async {
    await Provider.of<CharactersProvider>(context, listen: false)
        .fetchCharacters();
    _filterCharacters(_searchText);
  }

  void _searchCharacter(String searchText) {
    setState(() {
      _searchText = searchText.toLowerCase();
      _filterCharacters(_searchText);
    });
  }

  void _filterCharacters(String searchText) {
    _filteredCharacters = Provider.of<CharactersProvider>(context,
            listen: false)
        .characters
        .where((character) => character.name.toLowerCase().contains(searchText))
        .toList();
  }

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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: _searchCharacter,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar personaje',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _fetchAndFilterCharacters(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.error != null) {
                  return Center(child: Text('An error occurred!'));
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filteredCharacters.length,
                      itemBuilder: (ctx, i) => GestureDetector(
                        onTap: () {
                          _showCharacterInfo(context, _filteredCharacters[i]);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(16.0),
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              _filteredCharacters[i].image,
                              fit: BoxFit.cover,
                            ),
                          ),
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
