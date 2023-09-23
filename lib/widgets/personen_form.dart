import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/form_fields.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:galaxias_anmeldetool/models/anmelde_provider.dart';
import 'package:provider/provider.dart';

class PersonenForm extends StatefulWidget {
  final List<dynamic> genders;
  final List<dynamic> eatingHabits;
  final List<Map<String, dynamic>> savedPersons;
  final List<dynamic> bookingOptions;
  // final ValueChanged<List<Map<String, dynamic>>> onPersonsRegistered;

  const PersonenForm(
      {super.key, required this.genders, required this.eatingHabits, required this.savedPersons, required this.bookingOptions,});


  @override
  State<PersonenForm> createState() => _PersonenFormState();
}

class _PersonenFormState extends State<PersonenForm> {
  // List<Map<String, dynamic>> registeredPersons = [];

  // void _notifyPersonsChange() {
  //   if (widget.onPersonsRegistered != null) {
  //     widget.onPersonsRegistered(registeredPersons);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final anmeldeProvider = Provider.of<AnmeldeProvider>(context);
    final registeredPersons = anmeldeProvider.registeredPersons;
    final savedPersons = anmeldeProvider.savedPersons;
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
            final bookingOption = widget.bookingOptions.firstWhere(
                  (option) => option['id'].toString() == person['bookingOption'],
              orElse: () => null,
            );
            return Card(
              color: Colors.green[100],
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${person['firstName']} ${person['lastName']} ${bookingOption != null ? '(${bookingOption['name']} - ${bookingOption['price']} €)' : ''}'),
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
                                  initialValues: person,  // ensure you're passing the entire person
                                  genders: widget.genders,
                                  eatingHabits: widget.eatingHabits,
                                ),
                              ),
                            );
                            if (result is Map<String, dynamic>) {
                              setState(() {
                                registeredPersons[registeredPersons.indexOf(person)] = {
                                  ...result,
                                  if (person.containsKey('bookingOption'))
                                    'bookingOption': person['bookingOption'],
                                };
                              });
                              // _notifyPersonsChange();
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[400]),
                          child: Text('Bearbeiten', style: TextStyle(color: Colors.grey[100])),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              savedPersons.add(person);
                              registeredPersons.remove(person);
                            });
                            // _notifyPersonsChange();
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
            visible: savedPersons.isEmpty,
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
                  savedPersons.add(result);
                });
              }
            },
            child: const Text('Neue Person'),
          ),

          const SizedBox(
            height: 12.0,
          ),

          // Gespeicherte Personen
          ...savedPersons.map((person) {
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
                                savedPersons[savedPersons.indexOf(person)] =
                                    result;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[400]),
                          child: Text('Bearbeiten', style: TextStyle(color: Colors.grey[100])),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectBookingOption(bookingOptions: widget.bookingOptions),
                              ),
                            );
                            if (result is Map<String, dynamic>) {
                              setState(() {
                                final combinedPerson = {...person, ...result};
                                registeredPersons.add(combinedPerson);
                                savedPersons.remove(person);
                              });
                              // _notifyPersonsChange();
                            }
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

class SelectBookingOption extends StatefulWidget {
  final List<dynamic> bookingOptions;
  const SelectBookingOption({super.key, required this.bookingOptions});

  @override
  State<SelectBookingOption> createState() => _SelectBookingOptionState();
}

class _SelectBookingOptionState extends State<SelectBookingOption> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: const DPVAppBar(title: "Buchungsoption"),
      body: FormBuilder(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownInput(
              labelText: "Buchungsoption auswählen",
              idName: "bookingOption",
              data: widget.bookingOptions.map<Map<String, dynamic>>((item) {
                final Map<String, dynamic> castedItem = item as Map<String, dynamic>;
                return {
                  ...castedItem,
                  'name': castedItem['name'] + " - " + castedItem['price'] + " €"
                };
              }).toList(),
            ),
            const SizedBox(height: 8.0,),
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
                'Bestätigen',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

