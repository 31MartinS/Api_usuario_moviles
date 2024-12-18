import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/persona.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.8:5000/api/personas';

  // Obtener todas las personas
  Future<List<Persona>> getPersonas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Persona.fromJson(json)).toList();
    } else {
      print('Error al obtener personas: ${response.body}');
      throw Exception('Error al obtener personas');
    }
  }

  // Crear una nueva persona
  Future<Persona> createPersona(Persona persona) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(persona.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Decodificar directamente el JSON
      return Persona.fromJson(json.decode(response.body));
    } else {
      print('Error al crear persona: ${response.body}');
      throw Exception('Error al crear la persona');
    }
  }

  // Actualizar una persona
  Future<Persona> updatePersona(String id, Persona persona) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(persona.toJson()),
    );

    if (response.statusCode == 200) {
      // Decodificar directamente el JSON
      return Persona.fromJson(json.decode(response.body));
    } else {
      print('Error al actualizar persona: ${response.body}');
      throw Exception('Error al actualizar la persona');
    }
  }

  // Eliminar una persona
  Future<void> deletePersona(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      print('Error al eliminar persona: ${response.body}');
      throw Exception('Error al eliminar la persona');
    }
  }
}
