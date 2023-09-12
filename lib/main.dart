import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/screens/home.dart';
import 'package:galaxias_anmeldetool/screens/loading.dart';

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
        '/': (context) => const Loading(),
        '/home': (context) => const Home()
      },
    );
  }
}
