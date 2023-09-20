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
  List<dynamic> data = [];
  late bool isLoading;

  Future<void> fetchData() async {
    isLoading = true;
    final response = await http.get(Uri.parse('https://api.larskra.eu/modules'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        isLoading = false;
      });
    } else {
      // TODO: Handle the error or show an error screen
      isLoading = false;
      throw Exception('Failed to load data from the API');
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
          child: FormWidget(fetchedData: data),
        ),
      ),
    );
  }
}
