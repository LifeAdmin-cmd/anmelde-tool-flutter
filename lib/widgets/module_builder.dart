import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ModuleBuilder extends StatefulWidget {
  // final dynamic title;
  final Map<String, dynamic> modules;

  const ModuleBuilder({super.key, required this.modules});

  @override
  State<ModuleBuilder> createState() => _ModuleBuilderState();
}

class _ModuleBuilderState extends State<ModuleBuilder> {
  Widget _buildRow(
    List<Widget> widgets, {
    EdgeInsets padding = const EdgeInsets.only(bottom: 12.0),
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceAround,
  }) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: widgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("pageData: " + widget.modules.toString());
    // print(widget.param2.toString());
    return Column(
      children: [
        _buildRow(
          [
            Text(
              "${widget.modules['title']}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 22)
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Divider(),
        ),
        const BuchstabenInput(
          labelText: "Vorname",
          idName: "vorname",
        ),
        const BuchstabenInput(
          labelText: "Nachname",
          idName: "nachname",
        ),
        const InputSwitch(idName: 'accept', labelText: 'Akzeptieren', required: true,),
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

class InputSwitch extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;

  const InputSwitch({
    super.key,
    required this.labelText,
    required this.idName,
    required this.required,
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
        validator: (value) {
          if(widget.required && value != null && !value) {
            return "Diese Option ist erforderlich um fortzufahren";
          }
          return null;
        },
      ),
    );
  }
}

