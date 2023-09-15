import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';

class FahrtenAnsicht extends StatefulWidget {
  final Map<String, dynamic> fahrtenData;

  const FahrtenAnsicht({super.key, required this.fahrtenData});

  @override
  State<FahrtenAnsicht> createState() => _FahrtenAnsichtState();
}

class _FahrtenAnsichtState extends State<FahrtenAnsicht> {
  Map<String, dynamic> get fahrtenData => widget.fahrtenData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DPVAppBar(title: 'Anmeldung'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TODO make ActionButton only visible when editing is possible
            Text(fahrtenData.toString()),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const SizedBox(width: 16),
            FloatingActionButton.extended(
              onPressed: () {
                // TODO Anmelde-Prozess starten
              },
              label: const Text('Anmelden', style: TextStyle(color: Colors.white),),
              icon: const Icon(Icons.edit, size: 18, color: Colors.white,),
              backgroundColor: Colors.green[600],
            ),
          ],
        ),
      ),
    );
  }
}
