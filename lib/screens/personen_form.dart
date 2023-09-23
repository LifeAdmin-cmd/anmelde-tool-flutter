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
    return Expanded(
      child: FormBuilder(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const InputSwitch(labelText: "Person dauerhaft speichern", idName: "permSave", required: false, initialValue: true,), // TODO initialValue: true
              const BuchstabenInput(labelText: "Vorname", idName: "firstName"),
              const BuchstabenInput(labelText: "Nachname", idName: "lastName"),
              const BuchstabenInput(labelText: "Fahrtenname", idName: "scoutName", required: false,),
              const DateTimeInput(labelText: "Geburtsdatum", idName: "birthday"),
              DropdownInput(labelText: "Geschlecht", idName: "gender", data: widget.genders),
              ChoiceInput(labelText: "Essgewohnheiten", idName: "eatingHabits", data: widget.eatingHabits, required: false,),
              const BuchstabenInput(labelText: "Straße und Hausnummer", idName: "adress", regex: "",),
              const BuchstabenInput(labelText: "Postleitzahl", idName: 'plz', regex: r'\b\d+\b', regexError: "Eine PLZ kann nur aus Zahlen bestehen",), // TODO anders als im Backend

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  print(formKey.currentState!.instantValue);
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    // TODO do something
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
