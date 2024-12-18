import 'package:flutter/material.dart';
import '../controller/persona_controller.dart';
import '../models/persona.dart';

class PersonasView extends StatefulWidget {
  @override
  _PersonasViewState createState() => _PersonasViewState();
}

class _PersonasViewState extends State<PersonasView> {
  final PersonaController _controller = PersonaController();
  List<Persona> personas = [];

  final Color customColor = Color(0xFFB170FF);

  @override
  void initState() {
    super.initState();
    _cargarPersonas();
  }

  void _cargarPersonas() async {
    final data = await _controller.obtenerPersonas();
    setState(() {
      personas = data;
    });
  }

  Future<void> _mostrarDialogoPersona({Persona? persona}) async {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController nombreController = TextEditingController();
    final TextEditingController apellidoController = TextEditingController();
    final TextEditingController telefonoController = TextEditingController();

    if (persona != null) {
      nombreController.text = persona.nombre;
      apellidoController.text = persona.apellido;
      telefonoController.text = persona.telefono;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              persona == null ? 'Agregar Persona' : 'Actualizar Persona',
              style: TextStyle(
                color: customColor,
              ),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Ingrese el nombre' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: apellidoController,
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Ingrese el apellido' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: telefonoController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number, // Solo permite números en el teclado
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el teléfono';
                    }
                    // Verificar que solo contenga números
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'El teléfono debe ser números';
                    }
                    // Verificar longitud de 10 dígitos
                    if (value.length != 10) {
                      return 'El teléfono debe tener 10 dígitos';
                    }
                    // Verificar duplicados (excluir el número actual si es una actualización)
                    if (personas.any((p) => p.telefono == value && p.id != (persona?.id ?? ''))) {
                      return 'El número de teléfono ya existe';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: customColor, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customColor, // Botón principal
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    if (persona == null) {
                      await _controller.agregarPersona(Persona(
                        nombre: nombreController.text,
                        apellido: apellidoController.text,
                        telefono: telefonoController.text,
                      ));
                    } else {
                      await _controller.actualizarPersona(persona.id, Persona(
                        nombre: nombreController.text,
                        apellido: apellidoController.text,
                        telefono: telefonoController.text,
                      ));
                    }
                    Navigator.pop(context);
                    _cargarPersonas();
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al guardar datos'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(persona == null ? 'Agregar' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarPersona(String id) async {
    await _controller.eliminarPersona(id);
    _cargarPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PERSONAS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: customColor,
      ),
      body: personas.isEmpty
          ? Center(
        child: Text(
          'No hay personas registradas',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: personas.length,
        itemBuilder: (context, index) {
          final persona = personas[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: customColor,
                child: Text(
                  persona.nombre[0].toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                '${persona.nombre} ${persona.apellido}',
              ),
              subtitle: Text('Teléfono: ${persona.telefono}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: customColor),
                    onPressed: () => _mostrarDialogoPersona(persona: persona),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarPersona(persona.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoPersona(),
        child: Icon(Icons.add),
        backgroundColor: customColor,
      ),
    );
  }
}
