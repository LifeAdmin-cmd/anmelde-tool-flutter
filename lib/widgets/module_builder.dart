import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:galaxias_anmeldetool/widgets/form_fields.dart';
import 'package:provider/provider.dart';

import '../models/anmelde_provider.dart';

class ModuleBuilder extends StatefulWidget {
  final Map<String, dynamic> module;
  final Map<String, dynamic> currentPageData; // <-- Add this

  const ModuleBuilder({
    super.key,
    required this.module,
    required this.currentPageData, // <-- And this
  });

  @override
  State<ModuleBuilder> createState() => _ModuleBuilderState();
}

class _ModuleBuilderState extends State<ModuleBuilder> {
  Widget getFormField(formField) {
    final anmeldeProvider = Provider.of<AnmeldeProvider>(context, listen: false);
    switch (formField['type']) {
      case "stringAttribute": {
        return BuchstabenInput(labelText: formField['label'], idName: formField['id'], required: formField['required'] ?? true,);
      }
      case "booleanAttribute": {
        bool currentValue;

        // Check if a value is provided in pageData
        if (widget.currentPageData.containsKey(formField['id'])) {
          currentValue = widget.currentPageData[formField['id']];
        } else if (formField['initialValue'] != null) {
          currentValue = formField['initialValue'];
        } else {
          // Only if no value exists in pageData, use the initialValue from the formField (or default to false)
          currentValue = formField['initialValue'] ?? false;
        }

        return InputSwitch(
          labelText: formField['label'],
          idName: formField['id'],
          required: formField['required'],
          initialValue: currentValue,
        );
      }
      case "integerAttribute": {
        return IntegerInput(labelText: formField['label'], idName: formField['id'], regex: formField['regex'] ?? r'^-?[0-9]+$', regexError: formField['regexError'] ?? "Ungültige Eingabe. Nur Ganzzahlen erlaubt.", required: formField['reqired'] ?? true,);
      }
      case "floatAttribute": {
        return FloatInput(labelText: formField['label'], idName: formField['id'], regex: formField['regex'] ?? r'^-?[0-9]*\.?[0-9]+$', regexError: formField['regexError'] ?? "Ungültige Eingabe. Nur Fließkommazahlen erlaubt.", required: formField['reqired'] ?? true,);
      }
      case "dateTimeAttribute": {
        return DateTimeInput(labelText: formField['label'], idName: formField['id'], required: formField['required'] ?? true, inputType: formField['inputType'] ?? InputType.date, formatString: formField['formatString'] ?? "yyyy-MM-dd",);
      }
      case "textAttribute": {
        return TextFieldInput(labelText: formField['label'], idName: formField['id'], required: formField['required'] ?? true,);
      }
      case "travelAttribute": {
        int? findValueForKey(String key) {
          for (var entry in anmeldeProvider.pageData.entries) {
            if (entry.value.containsKey(key)) {
              var potentialValue = entry.value[key];
              if (potentialValue is int) {
                return potentialValue;
              } else if (potentialValue is String) {
                return int.tryParse(potentialValue);  // will return null if parsing fails
              }
            }
          }
          return null;
        }

        var value = findValueForKey('travelType');
        return TravelAttribute(initialTravelType: value, labelText: formField['label'], idName: formField['id'],);
      }
      case "conditionsAttribute": {
        dynamic findNestedKeyValue(Map<dynamic, dynamic> map, String key) {
          // If the current map contains the key, return its value
          if (map.containsKey(key)) {
            return map[key];
          }

          // If not, iterate over all map values and recursively check if any of them contains the key
          for (var value in map.values) {
            if (value is Map) {
              final result = findNestedKeyValue(value, key);
              if (result != null) {
                return result;
              }
            }
          }

          return null; // return null if the key wasn't found
        }
        var keyValue = findNestedKeyValue(anmeldeProvider.pageData, formField['id']);
        keyValue = keyValue ?? false;

        return FahrtenConditionsInput(labelText: formField['label'], idName: formField['id'], urlString: formField['linkUrl'] ?? "", introText: formField['introText'] ?? "", initialValue: keyValue,);
      }
      case "summaryAttribute": {
        return SummaryCard(pageData: anmeldeProvider.pageData, modules: anmeldeProvider.modules, persons: anmeldeProvider.registeredPersons,);
      }
    }
    return const Placeholder();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> module = widget.module;
    List<dynamic> inputFields = module['formFields'];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${module['title']}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),

        // const Divider(indent: 150.0, endIndent: 150.0,),

        Visibility(
          visible: module['introText'].isNotEmpty && module['introText'] != null, // TODO maybe add error handling for missing value in json
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 20),
              child: Column(
                children: [
                  Text(module['introText'],
                  textAlign: TextAlign.center,
                ),
                  // const Divider(indent: 100.0, endIndent: 100.0, height: 40.0,),
                ],
              ),
            )
        ),


        // Load FormFields dynamically
        for(var field in inputFields)
          getFormField(field)

        // BuchstabenInput(
        //   labelText: "Vorname",
        //   idName: "vorname",
        // ),
        // BuchstabenInput(
        //   labelText: "Nachname",
        //   idName: "nachname",
        // ),
        // InputSwitch(idName: inputFields[0]['id'], labelText: inputFields[0]['label'], required: inputFields[0]['required'],),
      ],
    );
  }
}
