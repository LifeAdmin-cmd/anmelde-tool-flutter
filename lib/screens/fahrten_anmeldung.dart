import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/models/anmelde_provider.dart';
import 'package:http/http.dart' as http;
import 'package:galaxias_anmeldetool/screens/loading.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/form_widget.dart';
import 'package:provider/provider.dart';

class FahrtenAnmeldung extends StatefulWidget {
  final List<dynamic> bookingOptions;
  final String fahrtenId;
  const FahrtenAnmeldung({super.key, required this.bookingOptions, required this.fahrtenId});

  @override
  State<FahrtenAnmeldung> createState() => _FahrtenAnmeldungState();
}

class _FahrtenAnmeldungState extends State<FahrtenAnmeldung> {
  List<dynamic> modules = [];
  List<dynamic> genders = [];
  List<dynamic> eatingHabits = [];
  List<Map<String, dynamic>> fetchedPersons = [];
  Map<String, dynamic> loadedAnmeldung = {};
  late bool isLoading;

  Future<void> fetchData() async {
    isLoading = true;

    final List<http.Response> responses = await Future.wait([
      http.get(Uri.parse('https://api.larskra.eu/modules')),
      http.get(Uri.parse('https://api.bundesapp.org/basic/gender/')),
      http.get(Uri.parse('https://api.bundesapp.org/basic/eat-habits/')),
      http.get(Uri.parse('https://api.larskra.eu/persons')),
      http.get(Uri.parse('https://api.larskra.eu/fahrten/${widget.fahrtenId}/anmeldung'))
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
        loadedAnmeldung = json.decode(utf8.decode(responses[4].bodyBytes));
        isLoading = false;

        /// clean data before using model again
        final anmeldeProvider = Provider.of<AnmeldeProvider>(
            context, listen: false);
        anmeldeProvider.clearData();

        if (loadedAnmeldung.isNotEmpty) {

          loadedAnmeldung['pageData'] = (loadedAnmeldung['pageData'] as Map<String, dynamic>).map<int, dynamic>(
                  (key, value) => MapEntry(int.parse(key), value)
          );

          final int personenIndex =
          modules.indexWhere((obj) => obj["title"] == "Personen");

          bool isSubset(Map subset, Map superset) {
            for (final key in subset.keys) {
              if (!superset.containsKey(key)) {
                return false;
              }

              if (subset[key] is List && superset[key] is List) {
                if (!(const ListEquality().equals(
                    subset[key], superset[key]))) {
                  return false;
                }
              } else if (subset[key] != superset[key]) {
                return false;
              }
            }
            return true;
          }

          final loadedPersons = (loadedAnmeldung['pageData'][personenIndex]['persons'] as List)
              .cast<Map<String, dynamic>>();
          fetchedPersons.removeWhere((person) =>
              loadedPersons.any((loadedPerson) =>
                  isSubset(person, loadedPerson)));

          anmeldeProvider.initPageDate(loadedAnmeldung['pageData']);
          for (var person in loadedPersons) {
            anmeldeProvider.addRegisteredPerson(person);
          }
        }

        for (var person in fetchedPersons) {
          anmeldeProvider.addSavedPerson(person);
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
          child: FormWidget(modules: modules, genders: genders, eatingHabits: eatingHabits, fetchedPersons: fetchedPersons, bookingOptions: widget.bookingOptions, fahrtenId: widget.fahrtenId),
        ),
      ),
    );
  }
}
