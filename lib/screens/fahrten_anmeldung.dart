import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:galaxias_anmeldetool/widgets/form_widget.dart';

class FahrtenAnmeldung extends StatefulWidget {
  const FahrtenAnmeldung({super.key});

  @override
  State<FahrtenAnmeldung> createState() => _FahrtenAnmeldungState();
}

class _FahrtenAnmeldungState extends State<FahrtenAnmeldung> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DPVAppBar(title: 'Anmeldung'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.grey[200],
          child: const FormWidget(),
        ),
      ),
    );
  }
}

class BuchstabenInput extends StatefulWidget {
  final String labelText;
  final String regex;
  final String regexError;
  final String idName;

  const BuchstabenInput({
    super.key,
    required this.labelText,
    required this.idName,
    this.regex = r'^[A-Za-z\s\u00C0-\u024F]+$',
    this.regexError = "Ungültige Eingabe. Nur Buchstaben erlaubt.",
  });

  @override
  State<BuchstabenInput> createState() => _BuchstabenInputState();
}

class _BuchstabenInputState extends State<BuchstabenInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormBuilderTextField(
        name: widget.idName,
        decoration: InputDecoration(
          labelText: widget.labelText,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Dieses Feld darf nicht leer sein.';
          }
          // Add regex pattern for Nachname validation here
          if (!RegExp(widget.regex).hasMatch(value)) {
            return widget.regexError;
          }
          return null; // Return null for no validation errors
        },
      ),
    );
  }
}
