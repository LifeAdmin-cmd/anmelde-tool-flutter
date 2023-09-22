import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/form_fields.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PersonenForm extends StatefulWidget {
  final List<dynamic> genders;
  final List<dynamic> eatingHabits;
  const PersonenForm({super.key, required this.genders, required this.eatingHabits});

  @override
  State<PersonenForm> createState() => _PersonenFormState();
}

class _PersonenFormState extends State<PersonenForm> {
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    String jsonString = '[{"id":1,"name":"Männlich","value":"M"},{"id":2,"name":"Weiblich","value":"F"},{"id":3,"name":"Divers","value":"D"},{"id":4,"name":"Keine Angabe","value":"N"}]';

// Parse the JSON string into a list of maps
    List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(json.decode(jsonString));
    print(widget.genders[0]['name']);
    print(widget.eatingHabits);
    return Expanded(
      child: FormBuilder(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputSwitch(labelText: "Person dauerhaft speichern", idName: "permSave", required: false,), // TODO initialValue: true
              BuchstabenInput(labelText: "Vorname", idName: "firstName"),
              BuchstabenInput(labelText: "Vorname", idName: "lastName"),
              BuchstabenInput(labelText: "Fahrtenname", idName: "scoutName", required: false,),
              DateTimeInput(labelText: "Geburtsdatum", idName: "birthday"),
              DropdownInput(labelText: "Geschlecht", idName: "gender", data: widget.genders),
              // TODO Essensgewohnheiten
              ChoiceInput(labelText: "Essgewohnheiten", idName: "eatingHabits", data: widget.eatingHabits),
              BuchstabenInput(labelText: "Straße und Hausnummer", idName: "adress", regex: "",),
              BuchstabenInput(labelText: "Postleitzahl", idName: 'plz', regex: r'\b\d+\b', regexError: "Eine PLZ kann nur aus Zahlen bestehen",), // TODO anders als im Backend

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  print(formKey.currentState!.instantValue);
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    // print(formKey.currentState!.instantValue);
                  }
                },
                child: const Text(
                  'Speichern',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

