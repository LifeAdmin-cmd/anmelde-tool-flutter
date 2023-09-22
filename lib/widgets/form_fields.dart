import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class BuchstabenInput extends StatefulWidget {
  final String labelText;
  final String regex;
  final String regexError;
  final String idName;
  final bool required;

  const BuchstabenInput({
    super.key,
    required this.labelText,
    required this.idName,
    this.regex = r'^[A-Za-z\s\u00C0-\u024F]+$',
    this.regexError = "Ungültige Eingabe. Nur Buchstaben erlaubt.",
    this.required = true,
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
          labelText: widget.labelText + (widget.required ? "*" : "" ),
        ),
        validator: (value) {
          if ((value == null || value.isEmpty) && widget.required) {
            return 'Dieses Feld darf nicht leer sein.';
          }
          // Add regex pattern for Nachname validation here
          // print(!RegExp(widget.regex).hasMatch(value!));
          if (value != null && !RegExp(widget.regex).hasMatch(value)) {
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
    this.required = true,
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
        title: Text(widget.labelText + (widget.required ? "*" : "" )),
        // TODO overwrites the saving of the state
        // initialValue: widget.initialValue,
        validator: (value) {
          // print(value);
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

class DateTimeInput extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;
  // final bool initialValue;

  const DateTimeInput({
    super.key,
    required this.labelText,
    required this.idName,
    this.required = true,
    // this.initialValue = false,
  });

  @override
  State<DateTimeInput> createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0,),
      child: FormBuilderDateTimePicker(
        name: widget.idName,
        inputType: InputType.date,
        format: DateFormat("yyyy-MM-dd"),
        decoration: InputDecoration(
          labelText: widget.labelText + (widget.required ? "*" : "" ),
        ),
        // name: widget.labelText,
        // TODO overwrites the saving of the state
        // initialValue: widget.initialValue,
        validator: (value) {
          // print(value);
          // TODO when dynamic initialValue is implemented this needs to be changed
          if(widget.required && value == null) {
            return "Dieses Feld darf nicht leer sein.";
          }
          return null;
        },
      ),
    );
  }
}

class DropdownInput extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;
  final String placeholder;
  final List<String> data;

  const DropdownInput({
    Key? key,
    required this.labelText,
    required this.idName,
    required this.data,
    this.required = true,
    this.placeholder = "Bitte wählen ...", // Include the placeholder in the constructor
  }) : super(key: key);

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  String? _selectedValue; // To store the selected value

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText, // Display labelText as a label above the dropdown
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          FormBuilderDropdown<String>(
            name: widget.idName,
            items: widget.data
                .map((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ))
                .toList(),
            decoration: InputDecoration(
              hintText: widget.placeholder, // Display placeholder always
              border: const OutlineInputBorder(),
            ),
            // onChanged: (value) {
            //   setState(() {
            //     _selectedValue = value;
            //   });
            // },
            validator: (value) {
              if (widget.required && (value == null || value.isEmpty)) {
                return "Bitte wähle eine Option aus.";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}