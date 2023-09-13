import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_drawer.dart';
import 'package:galaxias_anmeldetool/widgets/fahrten_cards.dart';

class FutureFahrten extends StatefulWidget {
  const FutureFahrten({super.key});

  @override
  State<FutureFahrten> createState() => _FutureFahrtenState();
}

class _FutureFahrtenState extends State<FutureFahrten> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DPVAppBar(title: "Zukünftige Fahrten"),
      drawer: DPVDrawer(),
      body: FahrtenCards(category: '',), // TODO add category label für future
    );
  }
}
