import '../models/persona.dart';
import '../services/api_service.dart';

class PersonaController {
  final ApiService _apiService = ApiService();

  Future<List<Persona>> obtenerPersonas() async {
    return await _apiService.getPersonas();
  }

  Future<void> agregarPersona(Persona persona) async {
    await _apiService.createPersona(persona);
  }

  Future<void> actualizarPersona(String id, Persona persona) async {
    await _apiService.updatePersona(id, persona);
  }

  Future<void> eliminarPersona(String id) async {
    await _apiService.deletePersona(id);
  }
}
