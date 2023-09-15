import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/screens/fahrten_list.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'DPV Anmelde-Tool',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(32, 86, 223, 1)),
        useMaterial3: true,
      ),
      // home: const Home(title: 'DPV Anmelde-Tool'),
      routes: {
        '/': (context) => const FahrtenList(category: '', title: 'Aktive Anmeldephase'), // TODO add correct category
        '/vergangeneFahrten': (context) => const FahrtenList(category: 'expired', title: 'Vergangene Fahrten'),
        '/futureFahrten': (context) => const FahrtenList(category: '', title: 'Zukünftige Fahrten'), // TODO add correct category
      },
    );
  }
}
