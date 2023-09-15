import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_drawer.dart';
import 'package:galaxias_anmeldetool/widgets/fahrten_cards.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DPVAppBar(title: "Anstehende Fahrten"),
      drawer: DPVDrawer(),
      body: FahrtenCards(category: '',), // TODO add category label für home
    );
  }
}
