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
          if (value != null && !RegExp(widget.regex).hasMatch(value)) {
            return widget.regexError;
          }
          return null;
        },
      ),
    );
  }
}

class InputSwitch extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;
  final bool initialValue;

  const InputSwitch({
    super.key,
    required this.labelText,
    required this.idName,
    this.required = true,
    this.initialValue = false,
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
        initialValue: widget.initialValue,
        validator: (value) {
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

  const DateTimeInput({
    super.key,
    required this.labelText,
    required this.idName,
    this.required = true,
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
        validator: (value) {
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
  final List<dynamic> data;

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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText + (widget.required ? "*" : "" ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          FormBuilderDropdown<String>(
            name: widget.idName,
            items: widget.data
                .map<DropdownMenuItem<String>>((dynamic value) {
              final Map<String, dynamic> item = value as Map<String, dynamic>;
              return DropdownMenuItem<String>(
                value: item['id'].toString(), // Assuming 'value' is a string or can be converted to one
                child: Text(item['name'].toString()), // Assuming 'name' is a string or can be converted to one
              );
            }).toList(),
            decoration: InputDecoration(
              hintText: widget.placeholder, // Display placeholder always
              border: const OutlineInputBorder(),
            ),
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

class ChoiceInput extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;
  final String placeholder;
  final List<dynamic> data;

  const ChoiceInput({
    Key? key,
    required this.labelText,
    required this.idName,
    required this.data,
    this.required = true,
    this.placeholder = "Bitte wählen ...",
  }) : super(key: key);

  @override
  State<ChoiceInput> createState() => _ChoiceInputState();
}

class _ChoiceInputState extends State<ChoiceInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText + (widget.required ? "*" : "" ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          FormBuilderFilterChip(
            name: widget.idName,
            // checkmarkColor: Colors.green,
            selectedColor: Colors.green[400],
            options: widget.data
                .map<FormBuilderChipOption<String>>((dynamic value) {
              final Map<String, dynamic> item = value as Map<String, dynamic>;
              return FormBuilderChipOption<String>(
                value: item['id'].toString(), // Assuming 'value' is a string or can be converted to one
                child: Text(item['name'].toString()), // Assuming 'name' is a string or can be converted to one
              );
            }).toList(),
            decoration: InputDecoration(
              hintText: widget.placeholder, // Display placeholder always
              border: const OutlineInputBorder(),
            ),
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

class IntegerInput extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;
  final String regexError;

  const IntegerInput({
    Key? key,
    required this.labelText,
    required this.idName,
    this.required = true,
    this.regexError = "Ungültige Eingabe. Nur Ganzzahlen erlaubt.",
  }) : super(key: key);

  @override
  State<IntegerInput> createState() => _IntegerInputState();
}

class _IntegerInputState extends State<IntegerInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormBuilderTextField(
        name: widget.idName,
        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: true),
        decoration: InputDecoration(
          labelText: widget.labelText + (widget.required ? "*" : ""),
        ),
        validator: (value) {
          if ((value == null || value.isEmpty) && widget.required) {
            return 'Dieses Feld darf nicht leer sein.';
          }
          if (value != null && !RegExp(r'^-?[0-9]+$').hasMatch(value)) {
            return widget.regexError;
          }
          return null;
        },
      ),
    );
  }
}

class FloatInput extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;
  final String regexError;

  const FloatInput({
    Key? key,
    required this.labelText,
    required this.idName,
    this.required = true,
    this.regexError = "Ungültige Eingabe. Nur Fließkommazahlen erlaubt.",
  }) : super(key: key);

  @override
  State<FloatInput> createState() => _FloatInputState();
}

class _FloatInputState extends State<FloatInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormBuilderTextField(
        name: widget.idName,
        keyboardType: const TextInputType.numberWithOptions(
            decimal: true, signed: true),
        decoration: InputDecoration(
          labelText: widget.labelText + (widget.required ? "*" : ""),
        ),
        validator: (value) {
          if ((value == null || value.isEmpty) && widget.required) {
            return 'Dieses Feld darf nicht leer sein.';
          }
          if (value != null &&
              !RegExp(r'^-?[0-9]*\.?[0-9]+$').hasMatch(value)) {
            return widget.regexError;
          }
          return null;
        },
      ),
    );
  }
}

class TextFieldInput extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;

  const TextFieldInput({
    Key? key,
    required this.labelText,
    required this.idName,
    this.required = true,
  }) : super(key: key);

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormBuilderTextField(
        name: widget.idName,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          labelText: widget.labelText + (widget.required ? "*" : ""),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if ((value == null || value.isEmpty) && widget.required) {
            return 'Dieses Feld darf nicht leer sein.';
          }
          return null;
        },
      ),
    );
  }
}

