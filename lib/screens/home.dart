import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:galaxias_anmeldetool/widgets/dpv_app_bar.dart';
import 'package:galaxias_anmeldetool/widgets/dpv_drawer.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> jsonData = []; // To store the JSON data

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the API when the widget is first created
  }

  Future<void> fetchData() async {
    // Make the API call and parse the JSON response
    final response = await http.get(Uri.parse('https://anmelde-tool.free.beeceptor.com/fahrten'));

    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DPVAppBar(title: "Anstehende Fahrten",),
      drawer: const DPVDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 8.0,),
            Expanded(
              child: ListView.builder(
                itemCount: jsonData.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = jsonData[index];
                  // Create a tile for each object in the JSON data
                  return Column(
                    children: [
                      const SizedBox(height: 8.0,),
                      Card(
                        color: Colors.grey[200],
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150,
                              child: ListTile(
                                trailing: const Icon(Icons.edit),
                                title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold),),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['shortDescription']),
                                    Text("Von ${DateFormat('d.M.y').format(DateTime.parse(item['startDate']))} bis ${DateFormat('d.M.y').format(DateTime.parse(item['endDate']))}"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 15.0,),
          ],
        ),
      ),
    );
  }
}
