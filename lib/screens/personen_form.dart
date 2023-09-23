import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
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
  List<Map<String, dynamic>> persons = []; // Updated to Map<String, dynamic>

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPersonForm(
                    genders: widget.genders,
                    eatingHabits: widget.eatingHabits,
                  ),
                ),
              );
              if (result is Map<String, dynamic>) {
                setState(() {
                  persons.add(result);
                });
              }
            },
            child: Text('Add New Person'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: persons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${persons[index]['firstName']} ${persons[index]['lastName']}'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewPersonForm(
                            initialValues: persons[index],
                            genders: widget.genders,
                            eatingHabits: widget.eatingHabits,
                          ),
                        ),
                      );
                      if (result is Map<String, dynamic>) {
                        setState(() {
                          persons[index] = result;
                        });
                      }
                    },
                    child: Text('Edit'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewPersonForm extends StatefulWidget {
  final Map<String, dynamic>? initialValues;
  final List<dynamic> genders;
  final List<dynamic> eatingHabits;
  const NewPersonForm({this.initialValues, required this.genders, required this.eatingHabits});

  @override
  State<NewPersonForm> createState() => _NewPersonFormState();
}

class _NewPersonFormState extends State<NewPersonForm> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DPVAppBar(title: "Person"),
      body: FormBuilder(
        key: formKey,
        initialValue: widget.initialValues ?? {},
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 25),
            child: Column(
              children: [
                const InputSwitch(labelText: "Person dauerhaft speichern", idName: "permSave", required: false, initialValue: true,),
                const BuchstabenInput(labelText: "Vorname", idName: "firstName"),
                const BuchstabenInput(labelText: "Nachname", idName: "lastName"),
                const BuchstabenInput(labelText: "Fahrtenname", idName: "scoutName", required: false,),
                const DateTimeInput(labelText: "Geburtsdatum", idName: "birthday"),
                DropdownInput(labelText: "Geschlecht", idName: "gender", data: widget.genders),
                ChoiceInput(labelText: "Essgewohnheiten", idName: "eatingHabits", data: widget.eatingHabits, required: false,),
                const BuchstabenInput(labelText: "Straße und Hausnummer", idName: "adress", regex: r"",),
                const BuchstabenInput(labelText: "Postleitzahl", idName: 'plz', regex: r'\b\d+\b', regexError: "Eine PLZ kann nur aus Zahlen bestehen",),
                const SizedBox(height: 12.0,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      var result = formKey.currentState!.instantValue;
                      Navigator.pop(context, result);
                    }
                  },
                  child: const Text(
                    'Speichern',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
