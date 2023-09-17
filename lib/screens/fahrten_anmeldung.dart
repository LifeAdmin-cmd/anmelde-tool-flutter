import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';

class FahrtenAnmeldung extends StatefulWidget {
  const FahrtenAnmeldung({super.key});

  @override
  State<FahrtenAnmeldung> createState() => _FahrtenAnmeldungState();
}

class _FahrtenAnmeldungState extends State<FahrtenAnmeldung> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DPVAppBar(title: 'Anmeldung'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.grey[200],
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const BuchstabenInput(labelText: "Vorname"),
                const BuchstabenInput(labelText: "Nachname"),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            // Validate the form when the button is pressed
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, proceed with your logic
                              print("Submitted");
                              print(_formKey.currentState);
                            }
                          },
                          child: const Text('Weiter', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuchstabenInput extends StatefulWidget {
  final String labelText;
  final String regex;
  final String regexError;

  const BuchstabenInput({
    super.key,
    required this.labelText,
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
      child: TextFormField(
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
