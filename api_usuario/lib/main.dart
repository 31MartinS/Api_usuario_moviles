import 'package:flutter/material.dart';
import 'views/personas_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Personas',
      home: PersonasView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
