import "package:flutter/material.dart";

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 5.0, // Añade sombra
        centerTitle: true, // Centra el título
        title: Text(
          "Rick and Morty Character",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu), // Ícono de menú
          onPressed: () {
            // Acción cuando se presione
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Acción de búsqueda
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert), // ícono de más opciones
            onPressed: () {
              // Mostrar más opciones
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Details about the character will appear here."),
      ),
    );
  }
}
