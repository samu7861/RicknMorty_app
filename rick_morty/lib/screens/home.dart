import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../providers/character_provider.dart";
import 'package:dots_indicator/dots_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  double _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!;
      });
    });
  }

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
                  return Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: Provider.of<CharactersProvider>(context)
                            .characters
                            .length,
                        itemBuilder: (ctx, i) {
                          return Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.30,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Image.network(
                                  Provider.of<CharactersProvider>(context)
                                      .characters[i]
                                      .image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DotsIndicator(
                            dotsCount: Provider.of<CharactersProvider>(context)
                                .characters
                                .length,
                            position: _currentIndex.round(),
                            decorator: DotsDecorator(),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
