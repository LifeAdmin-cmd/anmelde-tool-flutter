import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/anmelde_provider.dart';

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
          labelText: widget.labelText + (widget.required ? "*" : ""),
        ),
        validator: (value) {
          if ((value == null || value.isEmpty) && widget.required) {
            return 'Dieses Feld darf nicht leer sein.';
          }
          if (value != null &&
              value.isNotEmpty &&
              !RegExp(widget.regex).hasMatch(value)) {
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
      padding: const EdgeInsets.all(
        12.0,
      ),
      child: FormBuilderSwitch(
        name: widget.idName,
        title: Text(widget.labelText + (widget.required ? "*" : "")),
        // TODO overwrites the saving of the state
        initialValue: widget.initialValue,
        validator: (value) {
          // TODO when dynamic initialValue is implemented this needs to be changed
          if (widget.required && (value == null || !value)) {
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
      padding: const EdgeInsets.all(
        12.0,
      ),
      child: FormBuilderDateTimePicker(
        name: widget.idName,
        inputType: widget.inputType,
        format: DateFormat(widget.formatString),
        decoration: InputDecoration(
          labelText: widget.labelText + (widget.required ? "*" : ""),
        ),
        validator: (value) {
          // TODO when dynamic initialValue is implemented this needs to be changed
          if (widget.required && value == null) {
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
  final String? initialValue;
  final Function(String?)? onChanged;

  const DropdownInput({
    Key? key,
    required this.labelText,
    required this.idName,
    required this.data,
    this.required = true,
    this.placeholder = "Bitte wählen ...",
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue =
        widget.initialValue; // Initialize _selectedValue with initialValue
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText + (widget.required ? "*" : ""),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          FormBuilderDropdown<String>(
            name: widget.idName,
            items: widget.data.map<DropdownMenuItem<String>>((dynamic value) {
              final Map<String, dynamic> item = value as Map<String, dynamic>;
              return DropdownMenuItem<String>(
                value: item['id']
                    .toString(), // Assuming 'value' is a string or can be converted to one
                child: Text(item['name']
                    .toString()), // Assuming 'name' is a string or can be converted to one
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
            initialValue: _selectedValue,
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
            widget.labelText + (widget.required ? "*" : ""),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          FormBuilderFilterChip(
            name: widget.idName,
            // checkmarkColor: Colors.green,
            selectedColor: Colors.green[400],
            options:
                widget.data.map<FormBuilderChipOption<String>>((dynamic value) {
              final Map<String, dynamic> item = value as Map<String, dynamic>;
              return FormBuilderChipOption<String>(
                value: item['id']
                    .toString(), // Assuming 'value' is a string or can be converted to one
                child: Text(item['name']
                    .toString()), // Assuming 'name' is a string or can be converted to one
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
  final String regex;
  final String regexError;

  const IntegerInput({
    Key? key,
    required this.labelText,
    required this.idName,
    this.required = true,
    this.regex = r'^-?[0-9]+$',
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
        keyboardType:
            const TextInputType.numberWithOptions(decimal: false, signed: true),
        decoration: InputDecoration(
          labelText: widget.labelText + (widget.required ? "*" : ""),
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

class FloatInput extends StatefulWidget {
  final String labelText;
  final String idName;
  final bool required;
  final String regex;
  final String regexError;

  const FloatInput({
    Key? key,
    required this.labelText,
    required this.idName,
    this.required = true,
    this.regex = r'^-?[0-9]*\.?[0-9]+$',
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
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: InputDecoration(
          labelText: widget.labelText + (widget.required ? "*" : ""),
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
  final int? initialTravelType;
  final String idName;
  final String labelText;

  const TravelAttribute(
      {super.key,
      required this.initialTravelType,
      required this.idName,
      required this.labelText});

  @override
  State<TravelAttribute> createState() => _TravelAttributeState();
}

class _TravelAttributeState extends State<TravelAttribute> {
  String?
      _currentSelection; // 1. Add variable to hold current value from the dropdown

  @override
  void initState() {
    super.initState();

    if (widget.initialTravelType != null) {
      _currentSelection = widget.initialTravelType.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final anmeldeProvider =
        Provider.of<AnmeldeProvider>(context, listen: false);
    return Column(
      children: [
        const IntegerInput(
            labelText: "Anzahl Personen?", idName: "personCount"),
        DropdownInput(
          labelText: widget.labelText,
          idName: "travelType",
          data: anmeldeProvider.anreiseData,
          initialValue: _currentSelection,
          onChanged: (newValue) {
            setState(() {
              _currentSelection = newValue;
            });
          },
        ),
        const DateTimeInput(
            labelText: "Datum und Uhrzeit",
            idName: "travelDateTime",
            inputType: InputType.both,
            formatString: 'yyyy-MM-dd HH:mm'),
        _currentSelection == "3"
            ? IntegerInput(
                labelText: anmeldeProvider
                    .getInputLabelForDropdownValue(_currentSelection),
                idName: "reiseDetails")
            : BuchstabenInput(
                labelText: anmeldeProvider
                    .getInputLabelForDropdownValue(_currentSelection),
                idName: "reiseDetails",
                regex: r"",
              ),
      ],
    );
  }
}

class FahrtenConditionsInput extends StatefulWidget {
  final String labelText;
  final String idName;
  final String urlString;
  final String introText;
  final bool initialValue;
  final bool required;

  const FahrtenConditionsInput(
      {super.key,
      required this.labelText,
      this.urlString = "",
      required this.idName,
      this.introText = "",
      this.initialValue = false,
      this.required = true});

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
          const SizedBox(height: 8.0,),
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
                        const url =
                            'http://stammgalaxias.de/wp-content/uploads/2022/11/fahrtenbedinungen.pdf';
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
          InputSwitch(
            labelText: widget.labelText,
            idName: widget.idName,
            initialValue: widget.initialValue,
            required: widget.required,
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final Map<int, dynamic> pageData;
  final List<dynamic> modules;
  final List<Map<String, dynamic>> persons;

  const SummaryCard(
      {super.key,
      required this.pageData,
      required this.modules,
      required this.persons});

  @override
  Widget build(BuildContext context) {
    final anmeldeProvider =
        Provider.of<AnmeldeProvider>(context, listen: false);
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildCardContent(anmeldeProvider),
        ),
      ),
    );
  }

  List<Widget> _buildCardContent(provider) {
    List<Widget> contentWidgets = [];

    for (var i = 0; i < modules.length; i++) {
      var module = modules[i];
      var moduleData = pageData[i];

      if (module['title'] == "Personen") {
        contentWidgets.add(Column(
          children: [
            const Text("Personen",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
            ...persons
                .map((person) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 8.0),
                        Text(
                            "Name: ${person["firstName"]} ${person["lastName"]}"),
                        Text("Fahrtenname: ${person["scoutName"] ?? ""}"),
                        Text("Geschlecht: ${person["gender"]}"),
                        Text(
                            "Geburtstag: ${DateFormat('dd.MM.yyyy').format(person["birthday"])}"),
                        Text("Addresse: ${person["address"]}"),
                        Text("PLZ: ${person["plz"]}"),
                        Text("Buchungsoption: ${person["bookingOption"]}"),
                        Text(
                            "Essensbesonderheiten: ${person["eatingHabits"].join(', ')}"),
                        const SizedBox(height: 16.0),
                      ],
                    ))
                .toList(),
          ],
        ));
      } else if (module['title'] == "Zusammenfassung") {
        continue;
      } else if (moduleData != null) {
        if (module["title"].isNotEmpty) {
          contentWidgets.add(
            Text(
              module["title"],
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          );
          contentWidgets.add(const SizedBox(height: 8.0));
        }

        // Process form fields
        for (var field in module["formFields"]) {
          var id = field["id"];
          var label = field["label"];
          var type = field["type"];
          var value = moduleData[id];

          switch (type) {
            case "booleanAttribute":
              contentWidgets.add(Row(
                children: <Widget>[
                  Icon(value ? Icons.check_box : Icons.check_box_outline_blank),
                  const SizedBox(width: 8.0),
                  Expanded(child: Text(label)),
                ],
              ));
              break;
            case "stringAttribute":
            case "integerAttribute":
            case "floatAttribute":
            case "textAttribute":
              if (value != null) {
                contentWidgets.add(Text('$label: $value'));
              }
              break;
            case "dateTimeAttribute":
              if (value != null) {
                DateTime? dt = DateTime.tryParse(value);
                String formattedDate = dt != null
                    ? DateFormat('yyyy-MM-dd').format(dt)
                    : "Invalid date";
                contentWidgets.add(Text('$label: $formattedDate'));
              }
              break;
            case "travelAttribute":
              contentWidgets.add(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Anzahl Personen: ${moduleData['personCount']}"),
                  Text("Reiseart: ${provider.anreiseData.firstWhere((element) => element["id"] == 3, orElse: () => null)['name']}"),
                  Text("Zeitpunkt: ${DateFormat('dd.MM.yyy HH:mm').format(moduleData['travelDateTime'])}"),
                  Text("${provider.getInputLabelForDropdownValue(moduleData['travelType'])}: ${moduleData['reiseDetails']}"),
                ],
              ));
              break;
            case "conditionsAttribute":
              contentWidgets.add(Row(
                children: <Widget>[
                  Icon(value ? Icons.check_box : Icons.check_box_outline_blank),
                  const SizedBox(width: 8.0),
                  Expanded(child: Text(label)),
                ],
              ));
              break;
            case "summaryAttribute":
              // You might not want to display summary in the summary card itself,
              // since it could be recursive or redundant
              break;
            default:
              print('Unknown attribute type: $type');
              break;
          }
          contentWidgets
              .add(const SizedBox(height: 8.0)); // space between items
        }

        contentWidgets
            .add(const SizedBox(height: 16.0)); // space between sections
      }
    }

    return contentWidgets;
  }
}
