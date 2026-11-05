import 'package:flutter/material.dart';
import 'core/utils/constants.dart';
import 'routes/rutas.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Inventarioapp());
}

class Inventarioapp extends StatelessWidget {
  const Inventarioapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appNombre,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: colorPrincipal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: obtenerRutas(),
    );
  }
}