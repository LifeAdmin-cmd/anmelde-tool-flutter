import 'package:flutter/material.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_drawer.dart';
import 'package:galaxias_anmeldetool/widgets/fahrten_cards.dart';
import 'package:galaxias_anmeldetool/screens/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VergangeneFahrten extends StatefulWidget {
  const VergangeneFahrten({super.key});

  @override
  State<VergangeneFahrten> createState() => _VergangeneFahrtenState();
}

class _VergangeneFahrtenState extends State<VergangeneFahrten> {
  final String category = "expired";

  List<dynamic> jsonData = []; // To store the JSON data

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the API when the widget is first created
  }

  Future<void> fetchData() async {
    // Make the API call and parse the JSON response
    // TODO update to production URL
    final response = await http.get(Uri.parse('http://185.223.29.19:8080/fahrten'));

    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> allData = json.decode(response.body);
        final List<dynamic> categoryData =
        allData.where((item) => item['status'] == category).toList();
        jsonData = categoryData;
        isLoading = false; // Set isLoading to false when data is loaded
      });
    } else {
      isLoading = false; // Set isLoading to false in case of an error
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DPVAppBar(title: "Vergangene Fahrten"),
      drawer: const DPVDrawer(),
      body: isLoading
          ? const Loading()
          : FahrtenCards(category: category, data: jsonData), // Pass jsonData to FahrtenCards
    );
  }
}
