import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
          if (value != null && value.isNotEmpty && !RegExp(widget.regex).hasMatch(value)) {
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
  final InputType inputType;
  final String formatString;

  const DateTimeInput({
    super.key,
    required this.labelText,
    required this.idName,
    this.required = true,
    this.inputType = InputType.date,
    this.formatString = "yyyy-MM-dd",
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
        inputType: widget.inputType,
        format: DateFormat(widget.formatString),
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
  final Function(String?)? onChanged;

  const DropdownInput({
    Key? key,
    required this.labelText,
    required this.idName,
    required this.data,
    this.required = true,
    this.placeholder = "Bitte wählen ...",
    this.onChanged,
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
            onChanged: widget.onChanged,
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
          border: const OutlineInputBorder(),
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

class TravelAttribute extends StatefulWidget {
  const TravelAttribute({super.key});

  @override
  State<TravelAttribute> createState() => _TravelAttributeState();
}

class _TravelAttributeState extends State<TravelAttribute> {
  String? _currentSelection; // 1. Add variable to hold current value from the dropdown
  List<dynamic> data = [
    {
      "id": 1,
      "name": "Öffis"
    },
    {
      "id": 2,
      "name": "Reisebus"
    },
    {
      "id": 3,
      "name": "PKW"
    },
    {
      "id": 4,
      "name": "Sonstiges"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const IntegerInput(labelText: "Anzahl Personen?", idName: "personCount"),
        DropdownInput(
          labelText: "Reiseart",
          idName: "travelType",
          data: data,
          // 2. Add a listener for when the DropdownInput changes
          onChanged: (newValue) {
            setState(() {
              _currentSelection = newValue;
            });
          },
        ),
        const DateTimeInput(labelText: "Datum und Uhrzeit", idName: "travelDateTime", inputType: InputType.both, formatString: 'yyyy-MM-dd HH:mm'),
        _currentSelection == "3"
        ? IntegerInput(labelText: _getInputLabelForDropdownValue(_currentSelection), idName: "reiseDetails")
        : BuchstabenInput(
          labelText: _getInputLabelForDropdownValue(_currentSelection),
          idName: "reiseDetails",
        ),
      ],
    );
  }

  String _getInputLabelForDropdownValue(String? value) {
    switch (value) {
      case "1":
        return "Welcher Bahnhof?";
      case "2":
        return "Welche Reisegesellschaft?";
      case "3":
        return "Anzahl der PKW";
      case "4":
        return "Wie reist du an?";
      default:
        return "Details";
    }
  }
}

class FahrtenConditionsInput extends StatefulWidget {
  final String labelText;
  final String idName;
  final String urlString;
  final String introText;
  final bool initialValue;

  const FahrtenConditionsInput({super.key, required this.labelText, this.urlString = "", required this.idName, this.introText = "", this.initialValue = false});

  @override
  State<FahrtenConditionsInput> createState() => _FahrtenConditionsInputState();
}

class _FahrtenConditionsInputState extends State<FahrtenConditionsInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Visibility(
            visible: widget.introText.isNotEmpty,
            child: Text(
              widget.introText,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Visibility(
            visible: widget.urlString.isNotEmpty,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Bedingungen',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = 'http://stammgalaxias.de/wp-content/uploads/2022/11/fahrtenbedinungen.pdf';
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url);
                        } else {
                          throw 'Konnte $url nicht öffnen!';
                        }
                      },
                  ),
                ],
              ),
            ),
          ),
          InputSwitch(labelText: widget.labelText, idName: widget.idName, initialValue: widget.initialValue,),
        ],
      ),
    );
  }
}

