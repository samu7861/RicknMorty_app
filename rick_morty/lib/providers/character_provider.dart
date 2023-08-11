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
      throw error;
    }
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
