class Persona {
  String id;
  String nombre;
  String apellido;
  String telefono;

  Persona({this.id = '', required this.nombre, required this.apellido, required this.telefono});

  // JSON a objeto Persona
  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['_id'] ?? '',
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
    );
  }

  // Convierte objeto Persona a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
    };
  }
}
