import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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

class InputSwitch extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;
  // final bool initialValue;

  const InputSwitch({
    super.key,
    required this.labelText,
    required this.idName,
    this.required = false,
    // this.initialValue = false,
  });

  @override
  State<InputSwitch> createState() => _InputSwitchState();
}

class _InputSwitchState extends State<InputSwitch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0,),
      child: FormBuilderSwitch(
        name: widget.idName,
        title: Text(widget.labelText),
        // TODO overwrites the saving of the state
        // initialValue: widget.initialValue,
        validator: (value) {
          print(value);
          // TODO when dynamic initialValue is implemented this needs to be changed
          if(widget.required && (value == null || !value)) {
            return "Diese Option ist erforderlich um fortzufahren";
          }
          return null;
        },
      ),
    );
  }
}
