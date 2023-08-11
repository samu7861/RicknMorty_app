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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CharacterInfoBottomSheet(character: character),
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
                    hintText: 'Search for characters',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
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
                        child: Hero(
                          tag: 'character-${_filteredCharacters[i].id}',
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class CharacterInfoBottomSheet extends StatelessWidget {
  final Character character;

  const CharacterInfoBottomSheet({required this.character});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.95,
      minChildSize: 0.2,
      builder: (context, controller) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple, // Cambiar el color de fondo
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Hero(
                  tag: 'character-${character.id}',
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        character.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                character.name,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text('Status: ${character.status}',
                  style: TextStyle(color: Colors.white)),
              Text('Species: ${character.species}',
                  style: TextStyle(color: Colors.white)),
              Text('Type: ${character.type}',
                  style: TextStyle(color: Colors.white)),
              Text('Gender: ${character.gender}',
                  style: TextStyle(color: Colors.white)),
              Text('Origin: ${character.origin.name}',
                  style: TextStyle(color: Colors.white)),
              Text('Location: ${character.location.name}',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }
}
