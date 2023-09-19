import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


class ModuleBuilder extends StatefulWidget {
  final dynamic param1;
  final dynamic param2;

  const ModuleBuilder({super.key, required this.param1, required this.param2});

  @override
  State<ModuleBuilder> createState() => _ModuleBuilderState();
}

class _ModuleBuilderState extends State<ModuleBuilder> {
  @override
  Widget build(BuildContext context) {
    print("pageData: " + widget.param1.toString());
    // print(widget.param2.toString());
    return const Column(
      children: [
        BuchstabenInput(labelText: "Vorname", idName: "vorname",),
        // BuchstabenInput(labelText: "Nachname", idName: "nachname",)
      ],
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
          if (value == null || value.isEmpty) {
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