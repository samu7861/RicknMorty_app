import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character.dart';

class CharactersProvider with ChangeNotifier {
  List<Character> _characters = [];

  List<Character> get characters => _characters;

  Future<void> fetchCharacters() async {
    const url = 'https://rickandmortyapi.com/api/character';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        if (decodedData.containsKey('results') &&
            decodedData['results'] is List) {
          final List<dynamic> characterList = decodedData['results'];
          _characters = characterList
              .map((charJson) => Character.fromJson(charJson))
              .toList();
          notifyListeners();
        } else {
          throw Exception('Invalid data format.');
        }
      } else {
        throw Exception(
            'Failed to load characters with status code ${response.statusCode}.');
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
