import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character.dart';

class CharactersProvider with ChangeNotifier {
  List<Character> _characters = [];

  List<Character> get characters => _characters;

  static const _baseUrl = 'https://rickandmortyapi.com/api';
  final _charactersEndpoint = '$_baseUrl/character';

  Future<void> fetchCharacters() async {
    try {
      final response = await http.get(Uri.parse(_charactersEndpoint));

      if (response.statusCode == 200) {
        final List<dynamic> extractedData =
            json.decode(response.body)['results'] as List<dynamic>;

        _characters = extractedData
            .map((charJson) => Character.fromJson(charJson))
            .toList();

        notifyListeners();
      } else {
        throw HttpException(
            'Failed to load characters. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      // Aquí puedes manejar el error según tus necesidades.
      // Por ejemplo, podrías lanzar el error para luego capturarlo
      // en la interfaz de usuario y mostrar un mensaje apropiado.
      throw error;
    }
  }
}

// Esta clase es útil para manejar errores HTTP específicos.
class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
