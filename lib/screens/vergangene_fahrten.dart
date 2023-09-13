import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_drawer.dart';
import 'package:galaxias_anmeldetool/widgets/fahrten_cards.dart';

class VergangeneFahrten extends StatefulWidget {
  const VergangeneFahrten({super.key});

  @override
  State<VergangeneFahrten> createState() => _VergangeneFahrtenState();
}

class _VergangeneFahrtenState extends State<VergangeneFahrten> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DPVAppBar(title: "Vergangene Fahrten"),
      drawer: DPVDrawer(),
      body: FahrtenCards(category: 'expired',),
    );
  }
}
