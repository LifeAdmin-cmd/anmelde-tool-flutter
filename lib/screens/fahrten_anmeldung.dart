import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:galaxias_anmeldetool/screens/loading.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/form_widget.dart';

class FahrtenAnmeldung extends StatefulWidget {
  const FahrtenAnmeldung({super.key});

  @override
  State<FahrtenAnmeldung> createState() => _FahrtenAnmeldungState();
}

class _FahrtenAnmeldungState extends State<FahrtenAnmeldung> {
  List<dynamic> modules = [];
  List<dynamic> genders = [];
  List<dynamic> eatingHabits = [];
  List<Map<String, dynamic>> fetchedPersons = [];
  late bool isLoading;

  Future<void> fetchData() async {
    isLoading = true;

    final List<http.Response> responses = await Future.wait([
      http.get(Uri.parse('https://api.larskra.eu/modules')),
      http.get(Uri.parse('https://api.bundesapp.org/basic/gender/')),
      http.get(Uri.parse('https://api.bundesapp.org/basic/eat-habits/')),
      http.get(Uri.parse('https://api.larskra.eu/persons')),
    ]);

    // Check if all responses have status code 200
    final allResponsesSuccessful = responses.every((response) =>
    response.statusCode == 200);

    if (allResponsesSuccessful) {
      setState(() {
        modules = json.decode(utf8.decode(responses[0].bodyBytes));
        genders = json.decode(utf8.decode(responses[1].bodyBytes));
        eatingHabits = json.decode(utf8.decode(responses[2].bodyBytes));
        fetchedPersons = (json.decode(utf8.decode(responses[3].bodyBytes)) as List).cast<Map<String, dynamic>>();
        isLoading = false;

        for (var person in fetchedPersons) {
          if (person['birthday'] != null) {
            person['birthday'] = DateTime.parse(person['birthday'] as String);
          }
          if (person['eatingHabits'] != null) {
            List<String> personEatingHabits = (person['eatingHabits'] as List).map((item) => item.toString()).toList();
            person['eatingHabits'] = personEatingHabits;
          }
        }

        for (final entry in fetchedPersons) {
          for (final key in entry.keys) {
            final dynamic value = entry[key];
            print('$key: ${value.runtimeType}');
          }
        }
      });
    } else {
      // TODO: Handle the error or show an error screen
      isLoading = false;
      throw Exception('Failed to load data from one or more APIs');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DPVAppBar(title: 'Anmeldung'),
      body: isLoading ? const Loading() : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Colors.grey[200],
          child: FormWidget(modules: modules, genders: genders, eatingHabits: eatingHabits, fetchedPersons: fetchedPersons),
        ),
      ),
    );
  }
}
