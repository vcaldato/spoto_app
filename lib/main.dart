import 'package:flutter/material.dart';
import 'pages/lista_lugares_page.dart';
import 'pages/filtro_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spoto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A2420),
        ),
        useMaterial3: true,
      ),
      home: ListaLugaresPage(),
      routes: {
        FiltroPage.ROUTE_NAME: (_) => FiltroPage(),
      },
    );
  }
}