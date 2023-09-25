import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/form_fields.dart';

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
  Widget _buildRow(
    List<Widget> widgets, {
    EdgeInsets padding = const EdgeInsets.fromLTRB(12, 12, 12, 12),
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
          visible: module['introText'] != "", // TODO maybe add error handling for missing value in json
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
