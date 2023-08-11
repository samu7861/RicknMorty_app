import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/character.dart';

class CharactersProvider with ChangeNotifier {
  List<Character> _characters = [];

  List<Character> get characters => _characters;

  Future<void> fetchCharacters() async {
    const url = 'https://rickandmortyapi.com/api/character';
    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body)['results'] as List;
    _characters =
        extractedData.map((charJson) => Character.fromJson(charJson)).toList();
    notifyListeners();
  }
}
