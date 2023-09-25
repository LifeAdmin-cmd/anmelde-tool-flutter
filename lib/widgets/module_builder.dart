import 'package:flutter/material.dart';
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
    switch (formField['type']) {
      case "stringAttribute": {
        return BuchstabenInput(labelText: formField['label'], idName: formField['id']);
      }
      case "booleanAttribute": {
        bool currentValue;

        // Check if a value is provided in pageData
        if (widget.currentPageData.containsKey(formField['id'])) {
          currentValue = widget.currentPageData[formField['id']];
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
        return IntegerInput(labelText: formField['label'], idName: formField['id']);
      }
      case "floatAttribute": {
        return FloatInput(labelText: formField['label'], idName: formField['id']);
      }
      case "dateTimeAttribute": {
        return DateTimeInput(labelText: formField['label'], idName: formField['id']);
      }
      case "textAttribute": {
        return TextFieldInput(labelText: formField['label'], idName: formField['id']);
      }
      case "travelAttribute": {
        return const TravelAttribute();
      }
      case "conditionsAttribute": {
        final anmeldeProvider = Provider.of<AnmeldeProvider>(context, listen: false);
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

        return FahrtenConditionsInput(labelText: formField['label'], idName: formField['id'], urlString: formField['linkUrl'], initialValue: keyValue,);
      }
    }

    return const InputSwitch(idName: 'accept', labelText: 'Test failed', required: true,);
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

        const Divider(indent: 50.0, endIndent: 50.0,),

        Visibility(
          visible: module['introText'].isNotEmpty && module['introText'] != null, // TODO maybe add error handling for missing value in json
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  Text(module['introText']),
                  const Divider(indent: 50.0, endIndent: 50.0,),
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
