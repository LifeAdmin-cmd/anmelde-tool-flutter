import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/form_fields.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PersonenForm extends StatefulWidget {
  final List<dynamic> genders;
  final List<dynamic> eatingHabits;
  final List<Map<String, dynamic>> savedPersons;
  const PersonenForm(
      {super.key, required this.genders, required this.eatingHabits, required this.savedPersons});

  @override
  State<PersonenForm> createState() => _PersonenFormState();
}

class _PersonenFormState extends State<PersonenForm> {
  List<Map<String, dynamic>> registeredPersons = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Text(
            "Deine Personen",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const Divider(
            indent: 50.0,
            endIndent: 50.0,
          ),
          const Text(
            "Hier werden alle von dir gespeicherten Personen angezeigt",
            textAlign: TextAlign.center,
          ),
          const Divider(
            indent: 50.0,
            endIndent: 50.0,
          ),

          // Angemeldete Personen
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Angemeldete Personen",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              Text(
                "Hier werden alle von dir zu dieser Anmeldung hinzugefügten Personen angezeigt:",
                textAlign: TextAlign.start,
              ),
            ],
          ),

          Visibility(
            visible: registeredPersons.isEmpty,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 30,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Du hast der Anmeldung noch keine\nPerson hinzugefügt!",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),


          ...registeredPersons.map((person) {
            return Card(
              color: Colors.green[100],
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${person['firstName']} ${person['lastName']}'),
                    const SizedBox(height: 12.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewPersonForm(
                                  initialValues: person,
                                  genders: widget.genders,
                                  eatingHabits: widget.eatingHabits,
                                ),
                              ),
                            );
                            if (result is Map<String, dynamic>) {
                              setState(() {
                                registeredPersons[registeredPersons.indexOf(person)] =
                                    result;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[400]),
                          child: Text('Bearbeiten', style: TextStyle(color: Colors.grey[100])),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.savedPersons.add(person);
                              registeredPersons.remove(person);
                            });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]),
                          child: Text('Entfernen', style: TextStyle(color: Colors.grey[100])),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          const Divider(
            indent: 50.0,
            endIndent: 50.0,
            height: 40,
          ),

          // Gespeicherte Personen
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Gespeicherte Personen",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              Text(
                "Hier werden alle von dir zu gespeicherten Personen angezeigt. Füge sie der Anmeldung hinzu um sie anzumelden.",
                textAlign: TextAlign.start,
              ),
            ],
          ),

          Visibility(
            visible: widget.savedPersons.isEmpty,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 30,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Du hast bisher noch keine\nPersonen gespeichert",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10.0,),

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
                  widget.savedPersons.add(result);
                });
              }
            },
            child: const Text('Neue Person'),
          ),

          const SizedBox(
            height: 12.0,
          ),

          // Gespeicherte Personen
          ...widget.savedPersons.map((person) {
            return Card(
              color: Colors.deepOrange[200],
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${person['firstName']} ${person['lastName']}'),
                    const SizedBox(height: 12.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewPersonForm(
                                  initialValues: person,
                                  genders: widget.genders,
                                  eatingHabits: widget.eatingHabits,
                                ),
                              ),
                            );
                            if (result is Map<String, dynamic>) {
                              setState(() {
                                widget.savedPersons[widget.savedPersons.indexOf(person)] =
                                    result;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[400]),
                          child: Text('Bearbeiten', style: TextStyle(color: Colors.grey[100])),
                        ),
                        // TODO bookingOptions prompt
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              registeredPersons.add(person);
                              print(registeredPersons);
                              widget.savedPersons.remove(person);
                            });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
                          child: Text('Hinzufügen', style: TextStyle(color: Colors.grey[100]),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class NewPersonForm extends StatefulWidget {
  final Map<String, dynamic>? initialValues;
  final List<dynamic> genders;
  final List<dynamic> eatingHabits;
  const NewPersonForm(
      {this.initialValues, required this.genders, required this.eatingHabits});

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
                const InputSwitch(
                  labelText: "Person dauerhaft speichern",
                  idName: "permSave",
                  required: false,
                  initialValue: true,
                ),
                const BuchstabenInput(
                    labelText: "Vorname", idName: "firstName"),
                const BuchstabenInput(
                    labelText: "Nachname", idName: "lastName"),
                const BuchstabenInput(
                  labelText: "Fahrtenname",
                  idName: "scoutName",
                  required: false,
                ),
                const DateTimeInput(
                    labelText: "Geburtsdatum", idName: "birthday"),
                DropdownInput(
                    labelText: "Geschlecht",
                    idName: "gender",
                    data: widget.genders),
                ChoiceInput(
                  labelText: "Essensbesonderheiten",
                  idName: "eatingHabits",
                  data: widget.eatingHabits,
                  required: false,
                ),
                const BuchstabenInput(
                  labelText: "Straße und Hausnummer",
                  idName: "adress",
                  regex: r"",
                ),
                const BuchstabenInput(
                  labelText: "Postleitzahl",
                  idName: 'plz',
                  regex: r'\b\d+\b',
                  regexError: "Eine PLZ kann nur aus Zahlen bestehen",
                ),
                const SizedBox(
                  height: 12.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    final Map<String, dynamic> formData = formKey.currentState!.instantValue;
                    for (final dynamic value in formData.values) {
                      print(value.runtimeType);
                    }
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
