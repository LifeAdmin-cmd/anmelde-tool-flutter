import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/screens/loading.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/fahrten_cards.dart';

class FahrtenList extends StatefulWidget {
  final String category;
  final String title;
  const FahrtenList({super.key, required this.category, required this.title});

  @override
  State<FahrtenList> createState() => _FahrtenListState();
}

class _FahrtenListState extends State<FahrtenList> {
  // TODO add correct category

  late List<dynamic> jsonData = []; // To store the JSON data

  late Map<String, int> categoryCount;

  bool isLoading = true;

  late String nullText;

  void setNullText() {
    switch (widget.category) {
      case ('future'):
        nullText = "Es sind noch keine Fahrten für die Zukunft geplant";
      case ('expired'):
        nullText = "Es liegen noch keine Fahrten in der Vergangenheit";
      case ('active'):
        nullText = "Du bist aktuell zu keiner Veranstaltung eingeladen";
    }
  }

  @override
  void initState() {
    super.initState();
    setNullText();
    fetchData();
  }

  // function to fetch data
  Future<void> fetchData() async {
    // TODO update to production URL
    final response = await http.get(Uri.parse('http://185.223.29.19:8080/fahrten'));

    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> allData = json.decode(response.body);
        final List<dynamic> categoryData = allData.where((item) => item['status'] == widget.category).toList();
        categoryCount = countStatusValues(allData);
        jsonData = categoryData;
        isLoading = false; // Set isLoading to false when data is loaded
      });
    } else {
      // TODO add error screen
      isLoading = false;
      throw Exception('Failed to load data from the API');
    }
  }

  // Function to count status values
  Map<String, int> countStatusValues(List<dynamic> data) {
    Map<String, int> counts = {};
    for (var item in data) {
      final status = item['status'] as String;
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DPVAppBar(title: widget.title),
      drawer: isLoading ? const Loading() : DPVDrawer(categoryCount: categoryCount),
      body: isLoading
          ? const Loading()
          : FahrtenCards(category: widget.category, data: jsonData, nullText: nullText,), // Pass jsonData to FahrtenCards
    );
  }
}

// TODO Fahrten nach Datum sortieren
